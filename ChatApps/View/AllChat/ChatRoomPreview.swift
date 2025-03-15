//
//  ChatRoomPreview.swift
//  ChatApps
//
//  Created by Gary on 15/3/2025.
//

import SwiftUI

struct ChatRoomPreview: View {
    let chatRoom: ChatRoom
    let authService = UserAuthService.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                ChatAvatar(chatRoom: chatRoom)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(chatRoom.displayName(for: authService.currentUserID))
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        if chatRoom.isGroup {
                            Text("\(chatRoom.participants.count) Participants")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()

            }
            .padding()
            
            Divider()
            
            // Message Preview
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(getPreviewMessages(), id: \.id) { message in
                        MessagePreviewRow(message: message)
                    }
                }
                .padding()
            }
            Divider()
            
            .padding()
            
            
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
        .frame(width: 400, height: 200)
    }
    
    // Get lastest messages
    private func getPreviewMessages() -> [Message] {
        if let lastMessage = chatRoom.lastMessage {
            return [lastMessage]
        }
        return []
    }
}

// Signal Message
struct MessagePreviewRow: View {
    let message: Message
    let authService = UserAuthService.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Avatar
            MessageRow(message: message, isCurrentUser: message.senderID == authService.currentUserID)
            
//            if message.senderID != authService.currentUserID {
//                Circle()
//                    .fill(Color.randomNice())
//                    .frame(width: 32, height: 32)
//                    .overlay(
//                        Text(getSenderInitial(senderId: message.senderID))
//                            .font(.caption)
//                            .foregroundColor(.white)
//                    )
//            }
//            
//            VStack(alignment: message.senderID == authService.currentUserID ? .trailing : .leading, spacing: 4) {
//                if message.senderID != authService.currentUserID {
//                    Text(getSenderName(senderId: message.senderID))
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                
//                Text(message.text)
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    .background(
//                        message.senderID == authService.currentUserID ?
//                            Color.blue.opacity(0.2) : Color.gray.opacity(0.2)
//                    )
//                    .cornerRadius(16)
//                
//                Text(formatTime(timestamp: message.timestamp))
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
//            
//            if message.senderID == authService.currentUserID {
//                Spacer()
//                
//                Circle()
//                    .fill(Color.blue)
//                    .frame(width: 32, height: 32)
//                    .overlay(
//                        Text("You")
//                            .font(.caption)
//                            .foregroundColor(.white)
//                    )
//            }
        }
    }
    
    // 獲取發送者首字母
    private func getSenderInitial(senderId: String) -> String {
        let name = getSenderName(senderId: senderId)
        return String(name.prefix(1).uppercased())
    }
    
    // 獲取發送者名稱
    private func getSenderName(senderId: String) -> String {
        if senderId == authService.currentUserID {
            return "You"
        } else {
            // 這裡需要根據您的數據獲取用戶名稱
            return "User" // 替換為實際的用戶名稱獲取邏輯
        }
    }
    
    // 格式化時間戳
    private func formatTime(timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

#Preview {
    ChatRoomPreview(chatRoom: ChatRoom.sample)
}
