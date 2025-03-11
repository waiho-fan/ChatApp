//
//  ChatHeaderViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

class ChatHeaderViewModel: ObservableObject {
    let chatRoom: ChatRoom
    var chatAvatar: ChatAvatar
    var lastSeen: String
    
    init(chatRoom: ChatRoom, lastSeen: String) {
        self.chatRoom = chatRoom
        self.chatAvatar = .init(chatRoom: chatRoom)
        self.lastSeen = lastSeen
    }
    
    var displayName: String {
        chatRoom.displayName(for: currentUser.id)
    }
}
