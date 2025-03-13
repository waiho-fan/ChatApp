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
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel = LoginViewModel()
    @Binding var showSignUp: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to ChatApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            TextField("E-mail", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: viewModel.performLogin) {
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
            .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || appState.isLoading)
            
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
    
    
}

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel = SignUpViewModel()
    @Binding var showSignUp: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create an account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            TextField("Name", text: $viewModel.name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: viewModel.performSignUp) {
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
            .disabled(!viewModel.signUpButtonIsEnabled || appState.isLoading)
            
            Button(action: { showSignUp = false }) {
                Text("Already have an account? Log in")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
    

}

#Preview("AuthView", body: {
    @Previewable @StateObject var appState = AppState()

    AuthView()
        .environmentObject(appState)
})

#Preview("LoginView", body: {
    @Previewable @State var showSignUp: Bool = false
    @Previewable @StateObject var appState = AppState()

    LoginView(showSignUp: $showSignUp)
        .environmentObject(appState)
})

#Preview("SignUpView", body: {
    @Previewable @StateObject var appState = AppState()
    @Previewable @State var showSignUp: Bool = false

    SignUpView(showSignUp: $showSignUp)
        .environmentObject(appState)
})
