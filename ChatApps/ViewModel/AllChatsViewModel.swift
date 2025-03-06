//
//  AllChatsViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

class AllChatsViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var totalUnread: Int = 0
    @Published var totalMentions: Int = 0
    
    private let chatRoomService = ChatRoomService()
    
    init() {
        loadMockChatRooms()
    }
    
    func loadChatRooms() {
//        guard let currentUser = chatRoomService.current.user else { return }
        
        isLoading = true
        
        chatRoomService.getUserChatRooms(userID: currentUserID) { [weak self] chatRooms in
            DispatchQueue.main.async {
//                self?.chatRooms = chatRooms.sorted(by: { ($0.lastMessage?.timestamp ?? $0.createdAt) > ($1.lastMessage?.timestamp ?? $1.createdAt) })
                self?.chatRooms = chatRooms
                self?.isLoading = false
            }
        }
    }
    
    private func loadMockChatRooms() {
        chatRooms = ChatRoom.samples
    }
    
    func calculateBadges() {
//        totalUnread = chatRooms.reduce(0) { $0 + $1.unreadCount }
//        totalMentions = chatRooms.reduce(0) { $0 + $1.mentionCount }
    }
    
    var filteredChats: [ChatRoom] {
        if searchText.isEmpty {
            return chatRooms
        } else {
            return chatRooms.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
