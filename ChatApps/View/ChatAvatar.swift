//
//  ChatAvatar.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct ChatAvatar: View {
    let chat: ChatRoom
    
    var body: some View {
        ZStack {
            // Icon
            Circle()
                .fill(chat.avatarColor)
                .frame(width: 52, height: 52)
            
            // Letter for group
            if chat.isGroup {
                Text(firstLetters())
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                // Letter for private
                Text(String(chat.name.prefix(1)))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Test if Active
            if chat.name == "Daniel Atkins" {
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: 18, y: 18)
            }
        }
    }
    
    private func firstLetters() -> String {
        if chat.isGroup {
            let nameParts = chat.name.split(separator: ",").prefix(3)
            return nameParts.compactMap { String($0.trimmingCharacters(in: .whitespaces).prefix(1)) }.joined()
        } else {
            return String(chat.name.prefix(1))
        }
    }
}

#Preview {
    List {
        ForEach(ChatRoom.samples) { chat in
            ChatAvatar(chat: chat)
        }
    }
}
