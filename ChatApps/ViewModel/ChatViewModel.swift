//
//  ChatViewModel.swift
//  ChatApps
//
//  Created by Gary on 1/3/2025.
//

import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchMessage()
    }
    
    func fetchMessage() {
        db.collection("messages")
          .order(by: "timestamp", descending: true)
          .addSnapshotListener { [weak self] (snapshot, error) in
              guard let self = self else { return }
              
              if let error = error {
                  print("Error fetching messages: \(error.localizedDescription)")
                  return
              }
              
              guard let doc = snapshot?.documents else {
                  print("Error fetching messages: No data returned")
                  return
              }
              
              self.messages = doc.map { doc in
                  let data = doc.data()
                  return Message(id: doc.documentID, data: data)
//                  return Message(
//                      id: doc.documentID,
//                      text: data["text"] as? String ?? "",
//                      senderID: data["senderID"] as? String ?? "",
//                      timestamp: data["timestamp"] as? Timestamp?.dateValue ?? Date()
//                  )
              }
          }
    }
    
    func sendMessage(_ text: String, senderID: String) {
        let messageData: [String: Any] = [
            "text": text,
            "senderID": senderID,
            "timestamp": Timestamp()
        ]
        
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Message added successfully!")
            }
        }
    }
}
