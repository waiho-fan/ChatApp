//
//  LoginViewModel.swift
//  ChatApps
//
//  Created by Gary on 14/3/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    func performLogin() {
        errorMessage = ""
        
        UserAuthService.shared.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("Login Success - email: \(self.email), password: \(self.password)")
                
                break
            case .failure(let error):
                self.errorMessage = "Login Fail：\(error.localizedDescription)"
            }
        }
    }
    
    func signInWithGoogle() {
        UserAuthService.shared.signInWithGoogle { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                print("Login Success with Google: \(user)")
                
                break
            case .failure(let error):
                self.errorMessage = "Google Login Fail：\(error.localizedDescription)"
            }
        }
    }
    
    func signInWithFacebook() {
        UserAuthService.shared.signInWithFacebook { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("Login Success with Facebook")
                
                break
            case .failure(let error):
                self.errorMessage = "Facebook Login Fail：\(error.localizedDescription)"
            }
        }
    }
    
    func signInWithApple() {
        UserAuthService.shared.signInwitheApple { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("Login Success with Apple")
                
                break
            case .failure(let error):
                self.errorMessage = "Apple Login Fail：\(error.localizedDescription)"
            }
        }
    }
}
