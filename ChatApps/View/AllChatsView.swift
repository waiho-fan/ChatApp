//
//  AllChatsView.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct AllChatsView: View {
    @StateObject private var viewModel = AllChatsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.chats) { chat in
                NavigationLink(destination: ChatView()) {
                    ChatRow(chat: chat)
                }
            }
        }
    }
}

struct ChatRow: View {
    let chat: ChatSummary
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: chat.avatarName)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            // Message
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.name)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Text(chat.time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text(chat.lastMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Unread count
                    if chat.unreadCount > 0 {
                        Text("\(chat.unreadCount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationView {
        AllChatsView()
    }
}
