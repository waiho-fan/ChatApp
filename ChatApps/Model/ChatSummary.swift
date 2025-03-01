//
//  ChatSummary.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

struct ChatSummary: Identifiable {
    var id = UUID()
    let name: String
    let avatarName: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
}
