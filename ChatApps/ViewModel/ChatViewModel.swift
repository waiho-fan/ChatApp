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
    
    let currentUserID: String = "user123"
    
    let chat: ChatSummary
    var lastSeen: String
    
    init(chat: ChatSummary, lastSeen: String) {
        self.chat = chat
        self.lastSeen = lastSeen
        
        loadMockMessages()
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
              }
          }
    }
    
    // Text Message
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
    
    func sendMockMessage(_ text: String, senderID: String) {
        // 創建新訊息
        let newMessage = Message(
            id: "msg\(messages.count + 1)_\(UUID().uuidString.prefix(6))",
            text: text,
            senderID: senderID,
            timestamp: Date()
        )
        
        // 新增至訊息列表（保持時間排序）
        messages.insert(newMessage, at: 0)
        messages.sort { $0.timestamp < $1.timestamp }
    }
    
    private func loadMockMessages() {
            // 創建時間戳記，從現在開始往前推
            let now = Date()
            let calendar = Calendar.current
            
            // 創建一個對話序列
            var mockMessages: [Message] = []
            
            // 用戶1：user123 (當前使用者)
            // 用戶2：friend456
            
            // 第一條訊息 - 2分鐘前
            let time1 = calendar.date(byAdding: .minute, value: -20, to: now)!
            mockMessages.append(Message(
                id: "msg1",
                text: "Hi?",
                senderID: "friend456",
                timestamp: time1
            ))
            
            // 第二條訊息 - 18分鐘前
            let time2 = calendar.date(byAdding: .minute, value: -18, to: now)!
            mockMessages.append(Message(
                id: "msg2",
                text: "Pretty Good. What are you doing?",
                senderID: currentUserID,
                timestamp: time2
            ))
            
            // 第三條訊息 - 16分鐘前
            let time3 = calendar.date(byAdding: .minute, value: -16, to: now)!
            mockMessages.append(Message(
                id: "msg3",
                text: "I'm learning SwiftUI too!",
                senderID: "friend456",
                timestamp: time3
            ))
            
            // 第四條訊息 - 15分鐘前
            let time4 = calendar.date(byAdding: .minute, value: -15, to: now)!
            mockMessages.append(Message(
                id: "msg4",
                text: "Awsesome!. Keep up the good work!",
                senderID: currentUserID,
                timestamp: time4
            ))
            
            // 第五條訊息 - 13分鐘前
            let time5 = calendar.date(byAdding: .minute, value: -13, to: now)!
            mockMessages.append(Message(
                id: "msg5",
                text: "Message 5",
                senderID: "friend456",
                timestamp: time5
            ))
            
            // 第六條訊息 - 10分鐘前
            let time6 = calendar.date(byAdding: .minute, value: -10, to: now)!
            mockMessages.append(Message(
                id: "msg6",
                text: "Message 6",
                senderID: currentUserID,
                timestamp: time6
            ))
            
            // 第七條訊息 - 8分鐘前
            let time7 = calendar.date(byAdding: .minute, value: -8, to: now)!
            mockMessages.append(Message(
                id: "msg7",
                text: "Message 7",
                senderID: "friend456",
                timestamp: time7
            ))
            
            // 第八條訊息 - 5分鐘前
            let time8 = calendar.date(byAdding: .minute, value: -5, to: now)!
            mockMessages.append(Message(
                id: "msg8",
                text: "Message 8",
                senderID: currentUserID,
                timestamp: time8
            ))
            
            // 第九條訊息 - 2分鐘前
            let time9 = calendar.date(byAdding: .minute, value: -2, to: now)!
            mockMessages.append(Message(
                id: "msg9",
                text: "Message 9",
                senderID: "friend456",
                timestamp: time9
            ))
            
            // 第十條訊息 - 剛剛
            mockMessages.append(Message(
                id: "msg10",
                text: "Message 10",
                senderID: currentUserID,
                timestamp: now
            ))
            
            // 按時間排序（從新到舊）
            self.messages = mockMessages.sorted(by: { $0.timestamp < $1.timestamp })
        }
    
    // Image Message
    func sendImageMessage(_ text: String, imageURL: String, senderID: String) {
        
    }
    
    func sendMockImageMessage(_ text: String, imageURL: String, senderID: String) {
        let newMessage = Message(
            id: "msg\(messages.count + 1)_\(UUID().uuidString.prefix(6))",
            text: text,
            imageURL: imageURL,
            senderID: senderID,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messages.sort { $0.timestamp < $1.timestamp }
    }
    
    func sendMockMultiImageMessage(_ text: String, imageURLs: [String], senderID: String) {
        let newMessage = Message(
            id: "msg\(messages.count + 1)_\(UUID().uuidString.prefix(6))",
            text: text,
            imageURL: imageURLs.first ?? "",
            imageURLs: imageURLs,
            senderID: senderID,
            timestamp: Date()
        )
        
        messages.append(newMessage)
        messages.sort { $0.timestamp < $1.timestamp }
    }
}

extension Message {
    init(id: String, text: String, imageURL: String = "", imageURLs: [String] = [], senderID: String, timestamp: Date) {
        self.id = id
        self.text = text
        self.imageURL = imageURL
        self.imageURLs = imageURLs
        self.senderID = senderID
        self.timestamp = timestamp
    }
}
