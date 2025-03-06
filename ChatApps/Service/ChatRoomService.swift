//
//  ChatRoomService.swift
//  ChatApps
//
//  Created by Gary on 6/3/2025.
//

import FirebaseFirestore
import SwiftUI

class ChatRoomService {
    private let db = Firestore.firestore()
    
    func getUserChatRooms(userID: String, completion: @escaping ([ChatRoom]) -> Void) {
        db.collection("chatRooms")
            .whereField("participants", arrayContains: userID)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching chat rooms: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                
                let chatRooms = documents.map { document in
                    ChatRoom(id: document.documentID, data: document.data())
                }
                
//                print("Sccessfully fetched chat rooms: \(chatRooms)")
                completion(chatRooms)
            }
    }
    
    func createChatRoom(name: String, participants: [String], isGroup: Bool, completion: @escaping (String?) -> Void) {
        var colorData: [String: Double]? = nil
        
        let avatarColor = Color.randomNice()
        
        // Color Data for Firebase
//        if let color = avatarColor {
            // Color to RGB
            let uiColor = UIColor(avatarColor)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            colorData = [
                "red": Double(red),
                "green": Double(green),
                "blue": Double(blue)
            ]
//        }
        
        // Create data
        var chatRoomData: [String: Any] = [
            "name": name,
            "participants": participants,
            "createdAt": Timestamp(),
            "isGroup": isGroup
        ]
        
        if let colorData = colorData {
            chatRoomData["avatarColor"] = colorData
        }
        
//        print("Chat Room Data: \(chatRoomData)")
        
        var ref: DocumentReference? = nil
        ref = db.collection("chatRooms").addDocument(data: chatRoomData) { error in
            if let error = error {
                print("Error creating chat room: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(ref?.documentID)
        }
    }
    
    func getChatRoomMessages(chatRoomID: String, completion: @escaping ([Message]) -> Void) {
        db.collection("chatRooms").document(chatRoomID).collection("messages")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let doc = snapshot?.documents else {
                    print("Error fetching messages: No data returned")
                    completion([])
                    return
                }
                
                let messages = doc.map { doc in
                    var data = doc.data()
                    data["chatRoomID"] = chatRoomID
                    return Message(id: doc.documentID, data: data)
                }
                
                completion(messages)
            }
    }
    
    func sendMessage(chatRoomID: String, message: String, imageUrls: [String]? = [], senderID: String, senderName: String, completion: @escaping (Bool) -> Void) {
        let messageData: [String: Any] = [
            "text": message,
            "imageURLs": imageUrls ?? [],
            "senderID": senderID,
            "senderName": senderName,
            "timestamp": Timestamp(),
            "isRead": [senderID: true]
        ]
        
        db.collection("chatRooms").document(chatRoomID).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Update chatroom last message
            self.db.collection("chatRooms").document(chatRoomID).updateData([
                "lastMessage": messageData
            ]) { error in
                if let error = error {
                    print("Error updating last message: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
    }
    
    func markMessageAsRead(chatRoomID: String, messageID: String, userID: String) {
        db.collection("chatRooms").document(chatRoomID).collection("messages").document(messageID).updateData([
            "isRead.\(userID)": true
        ])
    }
    
}
