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
//                NavigationLink(destination: ChatView {
                    FriendRow(friend: friend)
//                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Friends")
    }
}

struct FriendRow: View {
    @StateObject var viewModel: FriendRowViewModel
    
    init(friend: Friend) {
        _viewModel = StateObject(wrappedValue: .init(friend: friend))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: viewModel.friend.avatarSystemName)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            // Friend info
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.friend.name)
                    .font(.system(size: 16, weight: .medium))
                
                HStack {
                    // Status
                    Circle()
                        .fill(viewModel.statusColor(status: viewModel.friend.status))
                        .frame(width: 8, height: 8)
                    
                    Text("\(viewModel.friend.status) • \(viewModel.friend.lastSeen)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    
}

#Preview {
    NavigationView {
        FriendListView()
    }
}
