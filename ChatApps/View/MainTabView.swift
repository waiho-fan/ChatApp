//
//  MainTabView.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 2/3/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                AllChatsView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Chat")
            }
            .tag(0)
            
            NavigationView {
                SettingView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Setting")
            }
            .tag(1)
        }
        .accentColor(.blue)
        .background(bgColor)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainTabView()
}
