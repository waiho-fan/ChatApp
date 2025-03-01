//
//  FriendListViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

class FriendListViewModel: ObservableObject {
    @Published var friends: [Friend] = []
    
    init() {
        loadMockFriends()
    }
    
    private func loadMockFriends() {
        friends = [
            Friend(name: "Benjamin Moore", avatarName: "person.fill", status: "Online", lastSeen: "11:44 AM"),
            Friend(name: "Emily Johnson", avatarName: "person.fill", status: "Away", lastSeen: "Yesterday"),
            Friend(name: "Michael Chen", avatarName: "person.fill", status: "Busy", lastSeen: "10:15 AM"),
            Friend(name: "Sophia Williams", avatarName: "person.fill", status: "Online", lastSeen: "Just now"),
            Friend(name: "David Rodriguez", avatarName: "person.fill", status: "Offline", lastSeen: "2 days ago"),
            Friend(name: "Olivia Kim", avatarName: "person.fill", status: "Online", lastSeen: "12:30 PM"),
            Friend(name: "James Wilson", avatarName: "person.fill", status: "Away", lastSeen: "3 hours ago"),
            Friend(name: "Emma Davis", avatarName: "person.fill", status: "Online", lastSeen: "9:50 AM")
        ]
    }
}
