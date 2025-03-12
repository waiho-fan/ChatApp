//
//  RootView.swift
//  ChatApps
//
//  Created by Gary on 13/3/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var authService = UserAuthService.shared
    
    var body: some View {
        ZStack {
            if appState.isLoading {
                LoadingView()
            } else if !appState.isAuthenticated {
                AuthView()
            } else {
                MainTabView()
            }
        }
        .onChange(of: authService.authState) { _, newState in
            switch newState {
            case .loading:
                appState.isLoading = true
                appState.authError = nil
            case .authenticated:
                appState.isLoading = false
                appState.isAuthenticated = true
                appState.authError = nil
            case .unauthenticated:
                appState.isLoading = false
                appState.isAuthenticated = false
                appState.authError = nil
            case .error(let message):
                appState.isLoading = false
                appState.authError = message
            case .unknown:
                appState.isLoading = true
                appState.authError = nil
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
            
            Text("Loading...")
                .font(.headline)
                .padding(.top, 20)
        }
    }
}

#Preview {
    @Previewable @StateObject var appState = AppState()
    RootView()
        .environmentObject(appState)
}
