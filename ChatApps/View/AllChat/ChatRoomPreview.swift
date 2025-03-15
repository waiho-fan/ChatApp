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
            MessageRow(message: message, isCurrentUser: message.senderID == authService.currentUserID, avatarSize: 36)
        }
    }
}

#Preview {
    ChatRoomPreview(chatRoom: ChatRoom.sample)
}
