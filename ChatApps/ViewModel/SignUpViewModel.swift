//
//  SignUpViewModel.swift
//  ChatApps
//
//  Created by Gary on 14/3/2025.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    var signUpButtonIsEnabled: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func performSignUp() {
        errorMessage = ""
        
        UserAuthService.shared.signUp(email: email, password: password, name: name) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(_):
                // Register Success - No need to handle navigation, handled by AppState
                break
            case .failure(let error):
                errorMessage = "Registration Failed：\(error.localizedDescription)"
            }
        }
    }
}
