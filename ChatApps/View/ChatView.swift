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
            List(viewModel.messages) { message in
                HStack {
                    if message.senderID == "user123" {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            
            HStack {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Send") {
                    viewModel.sendMessage(messageText, senderID: "user123")
                    messageText = ""
                }
            }
            .padding(.horizontal)
            
        }

    }
}

#Preview {
    ChatView()
        .preferredColorScheme(.dark)
}
