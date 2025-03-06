//
//  ChatRoomService.swift
//  ChatApps
//
//  Created by Gary on 6/3/2025.
//

import FirebaseFirestore

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
                
                print("Sccessfully fetched chat rooms: \(chatRooms)")
                completion(chatRooms)
            }
    }
    
    func createChatRoom(userID: String, participants: [String], isGroup: Bool, completion: @escaping (String?) -> Void) {
        return completion(nil)
    }
    
    func getChatRoomMessages(chatRoomID: String, completion: @escaping ([Message]) -> Void) {
        db.collection("messages")
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
        
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
                return
            } else {
                print("Message added successfully!")
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
