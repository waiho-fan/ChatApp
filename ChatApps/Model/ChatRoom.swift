//
//  ChatSummary.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct ChatRoom: Identifiable {
    var id = UUID()
    let name: String
    var isGroup: Bool = false
    var members: [String] = []
    let avatarColor: Color
    let lastMessage: String
    var isFromMe: Bool = false
    let time: String
    let unreadCount: Int
    var hasReadReceipt: Bool = false
    var mentionCount: Int = 0
   
}

extension ChatRoom {
    static var sample: ChatRoom {
        ChatRoom(
            name: "Daniel Atkins",
            avatarColor: Color(red: 0.2, green: 0.2, blue: 0.5),
            lastMessage: "The weather will be perfect for the st...",
            time: "2:14 PM",
            unreadCount: 1,
            hasReadReceipt: true
        )
    }
    
    static var samples: [ChatRoom] {
        return [
            // 單人聊天
            ChatRoom(
                name: "Daniel Atkins",
                avatarColor: Color(red: 0.2, green: 0.2, blue: 0.5),
                lastMessage: "The weather will be perfect for the st...",
                time: "2:14 PM",
                unreadCount: 1,
                hasReadReceipt: true
            ),
            
            // 群組聊天
            ChatRoom(
                name: "Erin, Ursula, Matthew",
                isGroup: true,
                members: ["Erin", "Ursula", "Matthew"],
                avatarColor: Color(red: 0.8, green: 0.5, blue: 0.3),
                lastMessage: "You: The store only has (gasp!) 2% m...",
                isFromMe: true,
                time: "2:14 PM",
                unreadCount: 1,
                hasReadReceipt: true
            ),
            
            // 群組聊天 - 大量未讀
            ChatRoom(
                name: "Photographers",
                isGroup: true,
                members: ["Philippe", "others"],
                avatarColor: Color(red: 0.2, green: 0.2, blue: 0.4),
                lastMessage: "@Philippe: Hmm, are you sure?",
                time: "10:16 PM",
                unreadCount: 80,
                hasReadReceipt: true
            ),
            
            // 群組聊天 - 較長成員名單
            ChatRoom(
                name: "Nelms, Clayton, Wagner, Morgan",
                isGroup: true,
                members: ["Nelms", "Clayton", "Wagner", "Morgan"],
                avatarColor: Color(red: 0.7, green: 0.3, blue: 0.3),
                lastMessage: "You: The game went into OT, it's gonn...",
                isFromMe: true,
                time: "Friday",
                unreadCount: 0
            ),
            
            // 單人聊天 - 無未讀
            ChatRoom(
                name: "Regina Jones",
                avatarColor: Color(red: 0.2, green: 0.3, blue: 0.3),
                lastMessage: "The class has open enrollment until th...",
                time: "12/28/20",
                unreadCount: 0
            ),
            
            // 單人聊天 - @提及
            ChatRoom(
                name: "Baker Hayfield",
                avatarColor: Color(red: 0.8, green: 0.8, blue: 0.3),
                lastMessage: "@waldo Is Cleveland nice in October?",
                time: "08/09/20",
                unreadCount: 0,
                mentionCount: 1
            ),
            
            // 單人聊天 - 無未讀
            ChatRoom(
                name: "Kaitlyn Henson",
                avatarColor: Color(red: 0.1, green: 0.1, blue: 0.4),
                lastMessage: "You: Can you mail my rent check?",
                isFromMe: true,
                time: "22/08/20",
                unreadCount: 0
            )
        ]
    }
}
