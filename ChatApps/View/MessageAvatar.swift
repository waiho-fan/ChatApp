//
//  MessageAvatar.swift
//  ChatApps
//
//  Created by Gary on 12/3/2025.
//

import SwiftUI

struct MessageAvatar: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        ZStack {
            // Icon
            Circle()
                .fill(isCurrentUser ? .blue.opacity(0.8) : .gray.opacity(0.8))
                .frame(width: 52, height: 52)
            
            // Letter for group
            Text(firstLetters())
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private func firstLetters() -> String {
        message.senderName?.prefix(1).uppercased() ?? ""
    }
}

#Preview {
    ForEach(Message.samples) { message in
        MessageAvatar(message: message, isCurrentUser: true)
        MessageAvatar(message: message, isCurrentUser: false)
    }
}
