//
//  UserAuthService.swift
//  ChatApps
//
//  Created by Gary on 13/3/2025.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
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
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "UserAuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to get user"])))
                return
            }
        
            self?.createUserDocument(for: firebaseUser, completion: { result in
                completion(result)
            })
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
    
    private func createUserDocument(for firebaseUser: FirebaseAuth.User, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        let avatarColor = Color.randomNice()
        let uiColor = UIColor(avatarColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Data will send
        let userData: [String: Any] = [
            "name": firebaseUser.displayName ?? "Anonymous",
            "email": firebaseUser.email ?? "",
            "createdAt": Timestamp(),
            "avatarColor": [
                "red": Double(red),
                "green": Double(green),
                "blue": Double(blue)
            ]
        ]
        
        self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let userInfo = UserInfo(id: firebaseUser.uid, name: userData["name"] as! String, avatarColor: avatarColor)
            self.currentUser = userInfo
            
            print("Successfully signed up user: \(userInfo)")
            completion(.success(userInfo))
        }
    }
    
    private func fetchUserDocument(for firebaseUser: FirebaseAuth.User, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        
    }
}

extension UserAuthService {
    func signInWithGoogle(completion: @escaping (Result<UserInfo, Error>) -> Void) {
        // Get client id
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "UserAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase client ID not found"])))
            return
        }
        
        // Create Google login config
        let config = GIDConfiguration(clientID: clientID)
        
        // Get current display UIViewController
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            completion(.failure(NSError(domain: "UserAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current view controller not found"])))
            return
        }
        
        // Start Google login flow
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result,
                  let idToken = result.user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "UserAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get ID token"])))
                return
            }
            
            // Create firebase credential
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            // User firebase to authenticate
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(NSError(domain: "UserAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to get Firebase User"])))
                    return
                }
                
                self.db.collection("users").document(firebaseUser.uid).getDocument { [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching user document: \(error)")
                        completion(.failure(error))
                        return
                    }
                    
                    let avatarColor = Color.randomNice()
                    let userInfo = UserInfo(id: firebaseUser.uid,
                                            name: firebaseUser.displayName ?? "User",
                                            avatarColor: avatarColor)
                    
                    if snapshot?.exists != true {
                        self.createUserDocument(for: firebaseUser, completion: completion)
                    } else {
                        if let data = snapshot?.data() {
                            let name = data["name"] as? String ?? firebaseUser.displayName ?? "User"
                            
                            let userAvatarColor: Color
                            if let colorData = data["avatarColor"] as? [String: Double],
                               let red = colorData["red"],
                               let green = colorData["green"],
                               let blue = colorData["blue"] {
                                userAvatarColor = Color(red: red, green: green, blue: blue)
                            } else {
                                userAvatarColor = avatarColor
                            }
                            
                            let existingUserInfo = UserInfo(id: firebaseUser.uid, name: name, avatarColor: userAvatarColor)
                            self.currentUser = existingUserInfo
//                            self.authState = .authenticated
                            print("Successfully signed in with existing Google user: \(existingUserInfo)")
                            completion(.success(existingUserInfo))
                        } else {
                            // 文檔存在但無數據（極少情況）
                            self.currentUser = userInfo
//                            self.authState = .authenticated
                            print("Successfully signed in with Firebase user: \(userInfo)")
                            completion(.success(userInfo))
                        }
                    }
                }
            
//                let user = UserInfo(id: firebaseUser.uid,
//                                name: firebaseUser.displayName ?? "User",
//                                avatarColor: .blue)
//                
//                print("Successfully signed in with Firebase user: \(user)")
//                                
//                completion(.success(user))
            }
            
        }
    }
    
    func signInWithFacebook(completion: @escaping (Result<Void, Error>) -> Void) {
        //
    }
    
    func signInwitheApple(completion: @escaping (Result<Void, Error>) -> Void) {
        //
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
