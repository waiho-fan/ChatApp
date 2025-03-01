//
//  FriendListView.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 2/3/2025.
//

import SwiftUI

struct FriendListView: View {
    @StateObject var viewModel = FriendListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.friends) { friend in
                NavigationLink(destination: ChatView()) {
                    FriendRow(friend: friend)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Friends")
    }
}

struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: friend.avatarSystemName)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            // Friend info
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.system(size: 16, weight: .medium))
                
                HStack {
                    // Status
                    Circle()
                        .fill(statusColor(status: friend.status))
                        .frame(width: 8, height: 8)
                    
                    Text("\(friend.status) • \(friend.lastSeen)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    private func statusColor(status: String) -> Color {
        switch status {
        case "Online":
            return .green
        case "Away":
            return .yellow
        case "Busy":
            return .red
        default:
            return .gray
        }
    }
}

#Preview {
    NavigationView {
        FriendListView()
    }
}
