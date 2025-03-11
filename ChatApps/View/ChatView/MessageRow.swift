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
                HStack(alignment: .top) {
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
    
    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
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
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(isCurrentUser ? .blue : .white)
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .clipShape(ChatBubbleShape(isFromCurrentUser: isCurrentUser))
                    .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
                
            }
            
            // Timestamp
            Text(timeString(from: message.timestamp))
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
        }
        .padding(.horizontal, 4)
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
        MessageRow(message: message, isCurrentUser: message.senderID == currentUser.id)
    }
}
