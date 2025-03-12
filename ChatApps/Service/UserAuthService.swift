//
//  UserAuthService.swift
//  ChatApps
//
//  Created by Gary on 13/3/2025.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserAuthService: ObservableObject {
    static let shared = UserAuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var currentUser: UserInfo?
    @Published var authState: AuthState = .unknown
    
    var currentUserID: String {
        UserAuthService.shared.currentUser?.id ?? ""
    }
    
    var currentUserName: String {
        UserAuthService.shared.currentUser?.name ?? "Anonymous"
    }
    
    enum AuthState {
        case unknown
        case authenticated
        case unauthenticated
        case loading
        case error(String)
    }
    
    private init() {
        // Observer state change
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                // if user login
                self?.fetchUserData(userId: user.uid)
            } else {
                // if user logout
                self?.currentUser = nil
                self?.authState = .unauthenticated
            }
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Fetch User Data Error：\(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Cannot get User Data")
                return
            }
            
            // Data
            let name = data["name"] as? String ?? "Anonymous"
            
            let avatarColor: Color
            if let colorData = data["avatarColor"] as? [String: Double],
               let red = colorData["red"],
               let green = colorData["green"],
               let blue = colorData["blue"] {
                avatarColor = Color(red: red, green: green, blue: blue)
            } else {
                avatarColor = Color.randomNice()
            }
            
            self?.currentUser = UserInfo(id: userId, name: name, avatarColor: avatarColor)
        }
    }
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                completion(.failure(NSError(domain: "UserAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get user id"])))
                return
            }
            
            let avatarColor = Color.randomNice()
            let uiColor = UIColor(avatarColor)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            // Data will send
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "createdAt": Timestamp(),
                "avatarColor": [
                    "red": Double(red),
                    "green": Double(green),
                    "blue": Double(blue)
                ]
            ]
            
            self?.db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let userInfo = UserInfo(id: userId, name: name, avatarColor: avatarColor)
                self?.currentUser = userInfo
                
                print("Successfully signed up user: \(userInfo)")
                completion(.success(userInfo))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        self.authState = .loading
        
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.authState = .error(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            guard let userId = result?.user.uid else {
                let error = NSError(domain: "UserAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get user ID"])
                self?.authState = .error(error.localizedDescription)

                completion(.failure(error))
                return
            }
            
            // Data will get
            self?.db.collection("users").document(userId).getDocument { snapshot, error in
                if let error = error {
                    self?.authState = .error(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let data = snapshot?.data() else {
                    let error = NSError(domain: "UserAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get user infomaion"])
                    self?.authState = .error(error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                let name = data["name"] as? String ?? "Anonymous"
                
                let avatarColor: Color
                if let colorData = data["avatarColor"] as? [String: Double],
                   let red = colorData["red"],
                   let green = colorData["green"],
                   let blue = colorData["blue"] {
                    avatarColor = Color(red: red, green: green, blue: blue)
                } else {
                    avatarColor = Color.randomNice()
                }
                
                let userInfo = UserInfo(id: userId, name: name, avatarColor: avatarColor)
                print("Login success! UserInfo: \(userInfo)")
                self?.currentUser = userInfo
                self?.authState = .authenticated
                completion(.success(userInfo))
            }
        }
    }
    
    func signOut() throws {
        self.authState = .loading
        try auth.signOut()
        self.currentUser = nil
        self.authState = .unauthenticated
    }
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func getAllUsers(completion: @escaping ([UserInfo]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Get all users error：\(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            // Data will 
            let users = documents.compactMap { document -> UserInfo? in
                let data = document.data()
                let userId = document.documentID
                let name = data["name"] as? String ?? "Anonymous"
                
                let avatarColor: Color
                if let colorData = data["avatarColor"] as? [String: Double],
                   let red = colorData["red"],
                   let green = colorData["green"],
                   let blue = colorData["blue"] {
                    avatarColor = Color(red: red, green: green, blue: blue)
                } else {
                    avatarColor = Color.randomNice()
                }
                
                return UserInfo(id: userId, name: name, avatarColor: avatarColor)
            }
            
            completion(users)
        }
    }
}

extension UserAuthService.AuthState: Equatable {
    static func == (lhs: UserAuthService.AuthState, rhs: UserAuthService.AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.authenticated, .authenticated),
            (.unauthenticated, .unauthenticated),
            (.unknown, .unknown):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}
