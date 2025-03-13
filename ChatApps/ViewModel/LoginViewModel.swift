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
}
