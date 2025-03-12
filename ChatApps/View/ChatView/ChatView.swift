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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ChatViewModel
    @State private var messageText: String = ""
    @State private var selectedImages: [UIImage]?
    
    private let authService = UserAuthService.shared

    init(chat: ChatRoom, lastSeen: String) {
        _viewModel = .init(wrappedValue: ChatViewModel(chatRoom: chat, lastSeen: lastSeen))
    }
    
    var body: some View {
        ZStack {
            bgColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ChatHeader(chatRoom: viewModel.chatRoom, lastSeen: viewModel.lastSeen, onBackTapped: {
                    presentationMode.wrappedValue.dismiss()
                })

                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageRow(message: message, isCurrentUser: message.senderID == authService.currentUserID)
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
                    //viewModel.sendMockMessage(messageText, senderID: currentUserID)
                    viewModel.sendTextMessage(messageText)
                    messageText = ""
                } onSendImages: { imageURLs in
//                    viewModel.sendMockMultiImageMessage(messageText, imageURLs: imageURLs, senderID: currentUser.id)
                    viewModel.sendImageMessage(text: messageText, imageURLs: imageURLs, senderID: authService.currentUserID)
                }
            }
            .navigationBarHidden(true)
        }
        .onChange(of: viewModel.messages.count) { _, _ in
            viewModel.loadMessage()
        }
        .onAppear {
            viewModel.loadMessage()
        }
    }
}

struct ChatHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ChatHeaderViewModel
    var onBackTapped: () -> Void
    
    init(chatRoom: ChatRoom, lastSeen: String, onBackTapped: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: .init(chatRoom: chatRoom, lastSeen: lastSeen))
        self.onBackTapped = onBackTapped
    }
    
    var body: some View {
        ZStack {
            bgColor
            
            HStack {
                HStack(spacing: 12) {
                    Button(action: onBackTapped) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    
                    // Icon
                    ChatAvatar(chatRoom: viewModel.chatRoom)
                    
                    // Name, status
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.displayName)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text(viewModel.lastSeen)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Close button
                    Button(action: onBackTapped) {
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

#Preview {
    NavigationView {
        ChatView(chat: ChatRoom.sample, lastSeen: "Active")
    }
}
