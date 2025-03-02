//
//  ChatHeaderViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

class ChatHeaderViewModel: ObservableObject {
    let chatSummary: ChatSummary
    var chatAvatar: ChatAvatar
    var lastSeen: String
    
    init(chatSummary: ChatSummary, lastSeen: String) {
        self.chatSummary = chatSummary
        self.chatAvatar = .init(chat: chatSummary)
        self.lastSeen = lastSeen
    }
}
