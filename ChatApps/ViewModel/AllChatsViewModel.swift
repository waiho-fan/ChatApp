//
//  AllChatsViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    @Published var chats: [ChatRoom] = []
    @Published var searchText: String = ""
    @Published var totalUnread: Int = 0
    @Published var totalMentions: Int = 0
    
    init() {
        loadMockChat()
    }
    
    private func loadMockChat() {
        chats = ChatRoom.samples
    }
    
    func calculateBadges() {
        totalUnread = chats.reduce(0) { $0 + $1.unreadCount }
        totalMentions = chats.reduce(0) { $0 + $1.mentionCount }
    }
    
    var filteredChats: [ChatRoom] {
        if searchText.isEmpty {
            return chats
        } else {
            return chats.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
