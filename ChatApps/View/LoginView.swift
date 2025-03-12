//
//  LoginView.swift
//  ChatApps
//
//  Created by Gary on 13/3/2025.
//

import SwiftUI

struct AuthView: View {
    @State private var showSignUp = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if let error = appState.authError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if showSignUp {
                SignUpView(showSignUp: $showSignUp)
            } else {
                LoginView(showSignUp: $showSignUp)
            }
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var showSignUp: Bool
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ChatApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            TextField("E-mail", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: performLogin) {
                if appState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Login")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(email.isEmpty || password.isEmpty || appState.isLoading)
            
            Button(action: {
                showSignUp = true
            }) {
                Text("Not a member? Sign Up")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
    
    private func performLogin() {
        errorMessage = ""
        
        UserAuthService.shared.signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                print("Login Success - email: \(self.email), password: \(self.password)")
                
                break
            case .failure(let error):
                errorMessage = "Login Fail：\(error.localizedDescription)"
            }
        }
    }
}

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var showSignUp: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create an account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: performSignUp) {
                if appState.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(name.isEmpty || email.isEmpty || password.isEmpty || appState.isLoading)
            
            Button(action: { showSignUp = false }) {
                Text("Already have an account? Log in")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
    
    private func performSignUp() {
        errorMessage = ""
        
        UserAuthService.shared.signUp(email: email, password: password, name: name) { result in
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
#Preview {
    @Previewable @State var showSignUp: Bool = false
    @Previewable @StateObject var appState = AppState()

    LoginView(showSignUp: $showSignUp)
        .environmentObject(appState)
}
