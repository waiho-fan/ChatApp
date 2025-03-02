//
//  Friend.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import Foundation

struct Friend: Identifiable {
    var id = UUID()
    let name: String
    let avatarName: String
    let status: String
    let lastSeen: String
    
    var avatarSystemName: String {
        return avatarName
    }
}

extension Friend {
    static let mockData: Friend = .init(
        name: "John Doe",
        avatarName: "person.circle.fill",
        status: "Online",
        lastSeen: "Yesterday"
    )
}
