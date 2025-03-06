//
//  ChatAvatar.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct ChatAvatar: View {
    let chatRoom: ChatRoom
    
    var body: some View {
        ZStack {
            // Icon
            Circle()
                .fill(randomColor())
                .frame(width: 52, height: 52)
            
            // Letter for group
            if chatRoom.isGroup {
                Text(firstLetters())
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                // Letter for private
                Text(String(chatRoom.name.prefix(1)))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Test if Active
            if chatRoom.name == "Daniel Atkins" {
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
        if chatRoom.isGroup {
            let otherParticipants = chatRoom.participants.filter { $0 != currentUserID }
        
            return otherParticipants.prefix(3)
                .compactMap {
                    String($0.trimmingCharacters(in: .whitespaces).prefix(1).uppercased())
                }.joined()
        } else {
            return String(chatRoom.name.prefix(1).uppercased())
        }
    }
    
    private func randomColor() -> Color {
        Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}

#Preview {
    List {
        ForEach(ChatRoom.samples) { chat in
            ChatAvatar(chatRoom: chat)
        }
    }
}
