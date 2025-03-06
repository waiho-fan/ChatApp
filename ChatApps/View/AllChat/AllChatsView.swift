//
//  AllChatsView.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct AllChatsView: View {
    @StateObject private var viewModel = AllChatsViewModel()
    
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
                        //
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
            
//            // 底部選項卡
//            HStack(spacing: 0) {
//                // 聊天標籤
//                VStack {
//                    ZStack {
//                        Image(systemName: "bubble.left.and.bubble.right.fill")
//                            .font(.system(size: 24))
//                        
//                        if viewModel.totalUnread > 0 {
//                            Text("\(viewModel.totalUnread)")
//                                .font(.system(size: 12, weight: .bold))
//                                .foregroundColor(.white)
//                                .frame(minWidth: 20, minHeight: 20)
//                                .background(Color.red)
//                                .clipShape(Capsule())
//                                .offset(x: 18, y: -10)
//                        }
//                    }
//                    Text("Chats")
//                        .font(.caption)
//                }
//                .foregroundColor(.blue)
//                .frame(maxWidth: .infinity)
//                
//                // 提及標籤
//                VStack {
//                    ZStack {
//                        Image(systemName: "at")
//                            .font(.system(size: 24))
//                        
//                        if viewModel.totalMentions > 0 {
//                            Text("\(viewModel.totalMentions)")
//                                .font(.system(size: 12, weight: .bold))
//                                .foregroundColor(.white)
//                                .frame(minWidth: 20, minHeight: 20)
//                                .background(Color.red)
//                                .clipShape(Capsule())
//                                .offset(x: 12, y: -10)
//                        }
//                    }
//                    Text("Mentions")
//                        .font(.caption)
//                }
//                .foregroundColor(.gray)
//                .frame(maxWidth: .infinity)
//            }
//            .padding(.vertical, 10)
//            .background(Color.white)
//            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .background(bgColor)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadChatRooms()
        }
    }
}

struct ChatRow: View {
    let chatRoom: ChatRoom
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ChatAvatar(chatRoom: chatRoom)
            
            // Chat info
            VStack(alignment: .leading, spacing: 4) {
                // Name, last seen
                HStack {
                    Text(chatRoom.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
//                        if chat.hasReadReceipt {
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 12))
//                                .foregroundColor(.blue)
//                        }
                        
                        Text("chat.time")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Unread & uncount
                HStack {
                    Text("chat.lastMessage")
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
    }
}

#Preview {
    NavigationView {
        AllChatsView()
    }
}
