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
    var imageURL: String?
    var imageURLs: [String]?
    var senderID: String
    var senderName: String?
    var chatRoomID: String
    var timestamp: Date
    var isRead: [String: Bool]?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.text = data["text"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.imageURLs = data["imageURLs"] as? [String] ?? []
        self.senderID = data["senderID"] as? String ?? ""
        self.senderName = data["sendName"] as? String ?? ""
        self.chatRoomID = data["chatRoomID"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
        self.isRead = data["isRead"] as? [String: Bool] ?? [:]
    }
}

extension Message {
    init(id: String, text: String, imageURL: String = "", imageURLs: [String] = [], senderID: String, senderName: String? = nil, chatRoomID: String = "", timestamp: Date, isRead: [String: Bool]? = nil) {
        self.id = id
        self.text = text
        self.imageURL = imageURL
        self.imageURLs = imageURLs
        self.senderID = senderID
        self.senderName = senderName
        self.chatRoomID = chatRoomID
        self.timestamp = timestamp
        self.isRead = isRead
    }
    
    static var sample: Message {
        Message(id: "1", text: "Hello, This is a sample message", imageURL: "", senderID: "user123", timestamp: Date())
    }
}
