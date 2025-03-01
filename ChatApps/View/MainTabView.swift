//
//  MainTabView.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                FriendListView()
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("Contact")
            }
            .tag(0)
            
            NavigationView {
                AllChatsView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Chat")
            }
            .tag(1)
            
            NavigationView {
                SettingView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Setting")
            }
            .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
