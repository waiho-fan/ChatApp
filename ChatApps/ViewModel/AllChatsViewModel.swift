//
//  AllChatsViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

class AllChatsViewModel: ObservableObject {
    @Published var chats: [ChatSummary] = []
    
    init() {
        loadMockChat()
    }
    
    private func loadMockChat() {
        chats = [
            ChatSummary(name: "Benjamin Moore", avatarName: "person.fill", lastMessage: "Let's get lunch! How about sushi?", time: "11:30 AM", unreadCount: 1),
            ChatSummary(name: "Emily Johnson", avatarName: "person.fill", lastMessage: "The project is almost done!", time: "Yesterday", unreadCount: 0),
            ChatSummary(name: "Michael Chen", avatarName: "person.fill", lastMessage: "Did you see the new movie?", time: "10:15 AM", unreadCount: 3),
            ChatSummary(name: "Sophia Williams", avatarName: "person.fill", lastMessage: "Thanks for your help!", time: "Just now", unreadCount: 0),
            ChatSummary(name: "David Rodriguez", avatarName: "person.fill", lastMessage: "Meeting at 3pm tomorrow", time: "2 days ago", unreadCount: 0),
            ChatSummary(name: "Olivia Kim", avatarName: "person.fill", lastMessage: "I'm working on my app design.", time: "12:30 PM", unreadCount: 2)
        ]
    }
}
