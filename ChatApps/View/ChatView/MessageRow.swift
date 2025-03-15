//
//  MessageRow.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 12/3/2025.
//

import SwiftUI

struct MessageRow: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                HStack(alignment: .bottom) {
                    Spacer()
                    MessageBubble(message: message, isCurrentUser: true)
                    MessageAvatar(message: message, isCurrentUser: true)
                }
            } else {
                HStack(alignment: .top) {
                    MessageAvatar(message: message, isCurrentUser: false)
                    MessageBubble(message: message, isCurrentUser: false)
                    Spacer()
                }
            }
        }
    }
}

// Message Bubble
struct MessageBubble: View {
    let message: Message
    let isCurrentUser: Bool
    
    private let authService = UserAuthService.shared
    
    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
            if message.senderID != authService.currentUserID {
                Text(getSenderName(senderId: message.senderID))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Image Message
            if let imageURLs = message.imageURLs, !imageURLs.isEmpty {
                VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                    MultiImageMessageView(imageURLs: imageURLs)
                        .frame(maxWidth: 240, maxHeight: 300)
                }
                .padding(4)
                .background(bgColor.opacity(0.3))
                .foregroundColor(isCurrentUser ? .white : .black)
                .clipShape(ChatBubbleShape(isFromCurrentUser: isCurrentUser))
                .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
            }
            
            
            // Message
            if !message.text.isEmpty {
                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isCurrentUser ? .blue.opacity(0.2) : .gray.opacity(0.2))
                    .clipShape(ChatBubbleShape(isFromCurrentUser: isCurrentUser))
            }
            
            // Timestamp
            Text(timeString(from: message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 4)
        .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
    
    private func getSenderName(senderId: String) -> String {
        if isCurrentUser {
            return "You"
        } else {
            return "User"
        }
    }
    
    // time formatter
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ForEach(Message.samples) { message in
        MessageRow(message: message, isCurrentUser: false)
        MessageRow(message: message, isCurrentUser: true)
    }
}
