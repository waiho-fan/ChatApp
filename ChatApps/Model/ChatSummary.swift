//
//  ChatSummary.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct ChatSummary: Identifiable {
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
