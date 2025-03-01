//
//  Message.swift
//  ChatApps
//
//  Created by Gary on 1/3/2025.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var senderID: String
    var timestamp: Date
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.text = data["text"] as? String ?? ""
        self.senderID = data["senderID"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}
