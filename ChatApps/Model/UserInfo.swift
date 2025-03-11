//
//  UserInfo.swift
//  ChatApps
//
//  Created by Gary on 12/3/2025.
//

import Foundation
import SwiftUI

struct UserInfo: Identifiable {
    let id: String
    let name: String
    let avatarColor: Color
}

extension UserInfo {
    static var sample: UserInfo {
        UserInfo(id: "user123", name: "User123", avatarColor: .indigo)
    }
    
    static var sample2: UserInfo {
        UserInfo(id: "friend456", name: "Emily Johnson", avatarColor: .blue)
    }
    
    static var samples: [UserInfo] = [
        UserInfo(id: "user123", name: "User123", avatarColor: .indigo),
        UserInfo(id: "friend456", name: "Emily Johnson", avatarColor: .blue),
        UserInfo(id: "user789", name: "Michael Chen", avatarColor: .green),
        UserInfo(id: "user101", name: "Sophia Williams", avatarColor: .purple),
        UserInfo(id: "user202", name: "David Rodriguez", avatarColor: .orange),
        UserInfo(id: "user303", name: "Olivia Kim", avatarColor: .pink),
        UserInfo(id: "user404", name: "James Wilson", avatarColor: .teal),
        UserInfo(id: "user505", name: "Emma Davis", avatarColor: .indigo)
    ]
}
