//
//  ChatView.swift
//  ChatApps
//
//  Created by Gary on 1/3/2025.
//

import SwiftUI

struct ChatView: View {
    @State private var messageText: String = ""
    @ObservedObject var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                 List {
                     ForEach(viewModel.messages) { message in
                         MessageRow(message: message, isCurrentUser: message.senderID == viewModel.currentUserID)
                             .id(message.id)
                             .listRowSeparator(.hidden)
                     }
                 }
                 .listStyle(.plain)
                 .onChange(of: viewModel.messages.count) { _, _ in
                     // When add new message, auto scroll
                     if let lastId = viewModel.messages.last?.id {
                         scrollView.scrollTo(lastId, anchor: .top)
                     }
                 }
             }
            
            // Message input
            VStack {
                Divider()
                HStack {
                    TextField("Enter Message...", text: $messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        if !messageText.trimmingCharacters(in: .whitespaces).isEmpty {
//                            viewModel.sendMessage(messageText, senderID: "user123")
                            viewModel.sendMockMessage(messageText, senderID: viewModel.currentUserID)
                            messageText = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                }
                .padding(.vertical, 8)
            }
            .background(Color(UIColor.systemBackground))
            
        }
        .navigationTitle("Chatroom")
    }
    
    struct MessageRow: View {
        let message: Message
        let isCurrentUser: Bool
        
        var body: some View {
            HStack {
                if isCurrentUser {
                    Spacer()
                    MessageBubble(message: message, isCurrentUser: true)
                } else {
                    MessageBubble(message: message, isCurrentUser: false)
                    Spacer()
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    // Message Bubble
    struct MessageBubble: View {
        let message: Message
        let isCurrentUser: Bool
        
        var body: some View {
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message.text)
                    .padding(10)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                
                // timestamp
                Text(timeString(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 8)
        }
        
        // time formatter
        private func timeString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

#Preview {
    NavigationView {
        ChatView()
            .preferredColorScheme(.dark)
    }
}
