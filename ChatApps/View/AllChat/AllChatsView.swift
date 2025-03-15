//
//  AllChatsView.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 2/3/2025.
//

import SwiftUI

struct AllChatsView: View {
    @StateObject private var viewModel = AllChatsViewModel()
    @State private var isShowingCreateChatRoom = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue.opacity(0.7))
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text("Stream Chat")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Edit Button
                    Button(action: {
                        isShowingCreateChatRoom = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                }
                .padding(.horizontal)
                
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("Search", text: $viewModel.searchText)
                        .padding(.vertical, 10)
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 8)
            .padding(.bottom, 4)
            
            // Chat List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredChats) { chat in
                        NavigationLink(destination: ChatView(chat: chat, lastSeen: "Active now")) {
                            ChatRow(chatRoom: chat)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Divider()
                            .padding(.leading, 76)
                    }
                }
            }
        }
        .background(bgColor)
        .navigationBarHidden(true)
        .sheet(isPresented: $isShowingCreateChatRoom) {
            CreateChatRoomView(viewModel: viewModel)
                .onAppear {
                    viewModel.loadAllUsers()
                }
        }
        .onAppear {
            viewModel.loadChatRooms()
        }
    }
}

struct ChatRow: View {
    let chatRoom: ChatRoom
    @State private var showingPreview = false
    private let authService = UserAuthService.shared
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ChatAvatar(chatRoom: chatRoom)
            
            // Chat info
            VStack(alignment: .leading, spacing: 4) {
                // Name, last seen
                HStack {
                    Text(chatRoom.displayName(for: authService.currentUserID))
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
//                        if chat.hasReadReceipt {
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 12))
//                                .foregroundColor(.blue)
//                        }
                        
                        Text(chatRoom.lastMessageTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Unread & uncount
                HStack {
                    Text(chatRoom.lastMessage?.text ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Spacer()
                    
//                    if chat.unreadCount > 0 {
//                        Text("\(chat.unreadCount)")
//                            .font(.system(size: 12, weight: .bold))
//                            .foregroundColor(.white)
//                            .frame(width: 20, height: 20)
//                            .background(Color.red)
//                            .clipShape(Circle())
//                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(bgColor)
        .onLongPressGesture {
            showingPreview = true
        }
        .contextMenu {
            Button(action: {
                //
            }) {
                Label("Mark as read", systemImage: "checkmark.circle")
            }
            Button(role: .destructive) {
                //
            } label: {
                Label("Delete chat", systemImage: "trash")
                    .foregroundColor(.red)
            }

        } preview: {
            ChatRoomPreview(chatRoom: chatRoom)
                
        }
        .sheet(isPresented: $showingPreview) {
            ChatRoomPreview(chatRoom: chatRoom)
        }
    }
}

#Preview {
    NavigationView {
        AllChatsView()
    }
}

#Preview("ChatRow", body: {
    ChatRow(chatRoom: ChatRoom.sample)
})
