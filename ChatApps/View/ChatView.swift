//
//  ChatView.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 1/3/2025.
//

import SwiftUI

let bgColor: Color = Color(red: 0.92, green: 0.95, blue: 0.98)

struct ChatView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel = ChatViewModel()
    @State private var messageText: String = ""
    
    var body: some View {
        ZStack {
            bgColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ChatHeader()

                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                MessageRow(message: message, isCurrentUser: message.senderID == viewModel.currentUserID)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                    .onChange(of: viewModel.messages.count) { _, _ in
                        // When add new message, auto scroll
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                scrollView.scrollTo(lastId, anchor: .top)
                            }
                        }
                    }
                    .onAppear {
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                scrollView.scrollTo(lastId, anchor: .top)
                            }
                        }
                    }
                }
                .background(bgColor)
                
                // Message input
                MessageInputView(messageText: $messageText) {
                    if !messageText.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.sendMockMessage(messageText, senderID: viewModel.currentUserID)
                        messageText = ""
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    struct ChatHeader: View {
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            ZStack {
                bgColor
                
                HStack {
                    HStack(spacing: 12) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        // Icon
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )
                        
                        // Name, status
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Benjamin Moore")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("Last seen 11:44 AM")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Close button
                        Button(action: {
                            //
                        }) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "xmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(height: 75)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
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
        }
    }
    
    // Message Bubble
    struct MessageBubble: View {
        let message: Message
        let isCurrentUser: Bool
        
        var body: some View {
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                // Message
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        isCurrentUser ?
                        Color.blue :
                            Color.white
                    )
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .clipShape(
                        ChatBubbleShape(isFromCurrentUser: isCurrentUser)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 0, y: 1)
                
                // Timestamp
                Text(timeString(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, 4)
        }
        
        // time formatter
        private func timeString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
    
    struct ChatBubbleShape: Shape {
        var isFromCurrentUser: Bool
        
        func path(in rect: CGRect) -> Path {
            let cornerRadius: CGFloat = 20
            
            let corners: UIRectCorner = isFromCurrentUser
                ? [.topLeft, .topRight, .bottomLeft]
                : [.topRight, .bottomRight, .bottomLeft]
            
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            return Path(path.cgPath)
        }
    }
    
    struct MessageInputView: View {
        @Binding var messageText: String
        var onSend: () -> Void
        
        var body: some View {
            VStack(spacing: 0) {
                Divider()
                
                HStack(spacing: 12) {
                    // Attach File
                    Button(action: {
                        //
                    }) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "paperclip")
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.leading, 8)
                    
                    // Message Box
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        TextField("Enter message...", text: $messageText)
                            .padding(.horizontal, 18)
                            .frame(height: 20)
                    }
                    
                    // Send Button
                    Button(action: onSend) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.trailing, 8)
                }
                .frame(height: 40)
                .padding(.vertical, 10)
                .background(bgColor)
            }
        }
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
}
