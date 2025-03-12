//
//  SettingView.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("username") private var username: String = "User123"
    @AppStorage("darkMode") private var darkMode: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    
    private let authService = UserAuthService.shared
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                HStack {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(authService.currentUser?.avatarColor.opacity(0.7) ?? .gray.opacity(0.3))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(authService.currentUserName)
                            .font(.headline)
                        Text(authService.currentUserID)
                            .font(.subheadline)
                        
                        Text("Click to edit")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                }
                .padding(.vertical, 8)
                
//                TextField("Username", text: $username)
            }
            
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) { _, newValue in
                        darkMode.toggle()
                    }
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                Toggle("Sound Enabled", isOn: $soundEnabled)
                    .disabled(!notificationsEnabled)
            }
            
            Section(header: Text("Chat Settings")) {
                NavigationLink(destination: Text("Chat Background Setting")) {
                    Text("Chat Background")
                }
                
                NavigationLink(destination: Text("Messages Font")) {
                    Text("Messages Font")
                }
                
                NavigationLink(destination: Text("Privacy & Security")) {
                    Text("Privacy & Security")
                }
            }
            
            Section(header: Text("About")) {
                NavigationLink(destination: Text("App Version：1.0.0\nDeveloper：Gary\nCopyright © 2025")) {
                    Text("App Info")
                }
                
                NavigationLink(destination: Text("Privacy Policy")) {
                    Text("Privacy Policy")
                }
                
                NavigationLink(destination: Text("Service Agreement")) {
                    Text("Service Agreement")
                }
            }
            
            Section {
                Button(action: {
                    do {
                        try authService.signOut()
                    } catch {
                        print("Logoout error: \(error)")
                    }
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Setting")
        .onAppear {
            print("Current user: \(authService.currentUser?.description)")
            print("Current appState: \($appState)")
        }
    }
}

#Preview {
    @Previewable @StateObject var appState = AppState()
    NavigationView {
        SettingView()
            .environmentObject(appState)
    }
}
