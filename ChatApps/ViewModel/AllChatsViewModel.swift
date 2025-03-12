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
        
        chatRoomService.getUserChatRooms(userID: currentUser.id) { [weak self] chatRooms in
            DispatchQueue.main.async {
                self?.chatRooms = chatRooms.sorted(by: { ($0.lastMessage?.timestamp ?? $0.createdAt) > ($1.lastMessage?.timestamp ?? $1.createdAt) })
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
    
    func createPrivateChat(with userID: String, userName: String, completion: @escaping (String?) -> Void) {
//            guard let currentUser = userService.currentUser else {
//                completion(nil)
//                return
//            }
            
        let currentUser = currentUser
        
            // 檢查是否已存在與該用戶的私聊
            let existingChatRoom = chatRooms.first { chatRoom in
                !chatRoom.isGroup &&
                chatRoom.participants.count == 2 &&
                chatRoom.participants.contains(currentUser.id) &&
                chatRoom.participants.contains(userID)
            }
            
            if let existingChatRoom = existingChatRoom {
                completion(existingChatRoom.id)
                return
            }
        
        let displayNames: [String: String] = [
            currentUser.id: userName,
            userID: currentUser.name
        ]
            
            // 創建新的私聊
        let participants = [currentUser.id, userID]
            chatRoomService.createChatRoom(
                name: userName, // 對方的名字作為聊天室名稱
                participants: participants,
                isGroup: false,
                displayNames: displayNames
            ) { chatRoomID in
                completion(chatRoomID)
            }
        }
        
        // 創建群聊
    func createGroupChat(name: String, participants: [String], completion: @escaping (String?) -> Void) {
        //            guard let currentUser = userService.currentUser else {
        //                completion(nil)
        //                return
        //            }
        let currentUser = currentUser
        
        var allParticipantIds = participants
        if !allParticipantIds.contains(currentUser.id) {
            allParticipantIds.append(currentUser.id)
        }
        
        var userIdToName: [String: String] = [currentUser.id: currentUser.name]
        
        for participantId in participants {
            let participantName = getUserName(participantId: participantId)
            userIdToName[participantId] = participantName
        }
        
        var displayNames: [String: String] = [:]
                
        print("All participant IDs: \(allParticipantIds)")
        // 為每個參與者創建顯示名稱
        for participantId in allParticipantIds {
            let otherParticipantNames = allParticipantIds
                .filter { $0 != participantId }
                .compactMap { userIdToName[$0] }
            
            print("Other ParticipantNames: \(otherParticipantNames)")
            
            if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                displayNames[participantId] = name
            } else {
                // Default name
                if otherParticipantNames.isEmpty {
                    displayNames[participantId] = "Group Chat"
                } else {
                    // Combine participant names
                    displayNames[participantId] = otherParticipantNames.joined(separator: ", ")
                }
            }
        }
        
//        let groupName = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
//        "Group Chat" : name
        
        chatRoomService.createChatRoom(
            name: name,
            participants: allParticipantIds,
            isGroup: true,
            displayNames: displayNames
        ) { chatRoomID in
            completion(chatRoomID)
        }
    }
    
    private func getUserName(participantId: String) -> String {

        let userIdToName: [String: String] = [
            "user123": "User123",
            "friend456": "Emily Johnson",
            "user789": "Michael Chen",
            "user101": "Sophia Williams",
            "user202": "David Rodriguez",
            "user303": "Olivia Kim",
            "user404": "James Wilson",
            "user505": "Emma Davis"
        ]
        
        return userIdToName[participantId] ?? "Unknown User"
    }
}

