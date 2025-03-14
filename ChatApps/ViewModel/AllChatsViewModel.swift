//
//  AllChatsViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI
import Combine

class AllChatsViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var totalUnread: Int = 0
    @Published var totalMentions: Int = 0
    
    private let chatRoomService = ChatRoomService()
    private let authService = UserAuthService.shared
    
    private var cancellables: Set<AnyCancellable> = []
    private let appState: AppState
    
    @Published var allUsers: [UserInfo] = []
    private var userIdToInfo: [String: UserInfo] = [:]
    
    init(appState: AppState = AppState.shared) {
        self.appState = appState
        
        // Subscribe login event
        appState.userDidLogoutPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.clearChatRooms()
            }
            .store(in: &cancellables)
        
        // Subscribe logout event
        appState.userDidLoginPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadChatRooms()
            }
            .store(in: &cancellables)
        
        if authService.isSignedIn {
            loadChatRooms()
        } else {
//            loadMockChatRooms()
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // For ChatRoom
    func loadChatRooms() {
//        guard let currentUser = chatRoomService.current.user else { return }
        
        isLoading = true
        
        chatRoomService.getUserChatRooms(userID: authService.currentUserID) { [weak self] chatRooms in
            DispatchQueue.main.async {
                self?.chatRooms = chatRooms.sorted(by: { ($0.lastMessage?.timestamp ?? $0.createdAt) > ($1.lastMessage?.timestamp ?? $1.createdAt) })
                self?.isLoading = false
            }
        }
    }
    
    private func loadMockChatRooms() {
        chatRooms = ChatRoom.samples
    }
    
    func clearChatRooms() {
        DispatchQueue.main.async {
            self.chatRooms.removeAll()
            self.totalUnread = 0
            self.totalMentions = 0
        }
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
        // 檢查是否已存在與該用戶的私聊
        let existingChatRoom = chatRooms.first { chatRoom in
            !chatRoom.isGroup &&
            chatRoom.participants.count == 2 &&
            chatRoom.participants.contains(authService.currentUserID) &&
            chatRoom.participants.contains(userID)
        }
        
        if let existingChatRoom = existingChatRoom {
            completion(existingChatRoom.id)
            return
        }
        
        let displayNames: [String: String] = [
            authService.currentUserID: userName,
            userID: authService.currentUserName
        ]
        
        // 創建新的私聊
        let participants = [authService.currentUserID, userID]
        chatRoomService.createChatRoom(
            name: userName, // 對方的名字作為聊天室名稱
            participants: participants,
            isGroup: false,
            displayNames: displayNames
        ) { chatRoomID in
            completion(chatRoomID)
        }
    }
    
    func createGroupChat(name: String, participants: [String], completion: @escaping (String?) -> Void) {
        var allParticipantIds = participants
        if !allParticipantIds.contains(authService.currentUserID) {
            allParticipantIds.append(authService.currentUserID)
        }
        
        var userIdToName: [String: String] = [authService.currentUserID: authService.currentUserName]
        
        for participantId in participants {
            let participantName = getUserName(participantId: participantId)
            userIdToName[participantId] = participantName
        }
        
        var displayNames: [String: String] = [:]
                
//        print("All participant IDs: \(allParticipantIds)")
        // All participant names
        for participantId in allParticipantIds {
            let otherParticipantNames = allParticipantIds
                .filter { $0 != participantId }
                .compactMap { userIdToName[$0] }
            
//            print("Other ParticipantNames: \(otherParticipantNames)")
            
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
    
    // For User
    func loadAllUsers() {
        if !allUsers.isEmpty { return }
        
        isLoading = true
        
        authService.getAllUsers { [weak self] users in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.allUsers = users
                
                self.userIdToInfo = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
                
                self.isLoading = false
            }
        }
    }
    
    private func getUserName(participantId: String) -> String {

//        let userIdToName: [String: String] = [
//            "user123": "User123",
//            "friend456": "Emily Johnson",
//            "user789": "Michael Chen",
//            "user101": "Sophia Williams",
//            "user202": "David Rodriguez",
//            "user303": "Olivia Kim",
//            "user404": "James Wilson",
//            "user505": "Emma Davis"
//        ]
//        
//        return userIdToName[participantId] ?? "Unknown User"
        if let userInfo = userIdToInfo[participantId] {
            return userInfo.name
        }
        
        if participantId == authService.currentUserID {
            return authService.currentUserName
        }
        
        return "Unknown User"
    }
}

