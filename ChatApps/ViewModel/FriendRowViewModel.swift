//
//  FriendRowViewModel.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

class FriendRowViewModel: ObservableObject {
    @Published var friend: Friend
    
    init(friend: Friend) {
        self.friend = friend
    }
    
    func statusColor(status: String) -> Color {
        switch status {
        case "Online":
            return .green
        case "Away":
            return .yellow
        case "Busy":
            return .red
        default:
            return .gray
        }
    }
}
