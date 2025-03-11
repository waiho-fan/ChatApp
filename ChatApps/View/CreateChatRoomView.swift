//
//  CreateChatRoomView.swift
//  ChatApps
//
//  Created by Gary on 6/3/2025.
//

import SwiftUI

struct CreateChatRoomView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AllChatsViewModel
    
    // State variables for input fields
    @State private var roomName: String = ""
    @State private var isGroup: Bool = false
    @State private var selectedParticipants: [UserInfo] = []
    @State private var searchText: String = ""
    
    // Mock user data for demonstration
    @State private var availableUsers: [UserInfo] = UserInfo.samples
    
    // Computed property for filtered users
    private var filteredUsers: [UserInfo] {
        if searchText.isEmpty {
            return availableUsers
        } else {
            return availableUsers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                createHeader()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Group toggle
                        Toggle("Create Group Chat", isOn: $isGroup)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // Group name field (only visible if isGroup is true)
                        if isGroup {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Group Name")
                                    .font(.headline)
                                
                                TextField("Enter group name", text: $roomName)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Search field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Participants")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search users", text: $searchText)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Selected participants
                        if !selectedParticipants.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Selected (\(selectedParticipants.count))")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(selectedParticipants) { user in
                                            VStack {
                                                ZStack(alignment: .topTrailing) {
                                                    Circle()
                                                        .fill(user.avatarColor)
                                                        .frame(width: 60, height: 60)
                                                        .overlay(
                                                            Text(String(user.name.prefix(1)))
                                                                .font(.title2)
                                                                .foregroundColor(.white)
                                                        )
                                                    
                                                    Button(action: {
                                                        removeParticipant(user)
                                                    }) {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(.white)
                                                            .background(Circle().fill(Color.red))
                                                    }
                                                    .offset(x: 5, y: -5)
                                                }
                                                
                                                Text(user.name)
                                                    .font(.caption)
                                                    .lineLimit(1)
                                            }
                                            .frame(width: 70)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        // Available users list
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Available Users")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(filteredUsers) { user in
                                if !isUserSelected(user) {
                                    Button(action: {
                                        addParticipant(user)
                                    }) {
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(user.avatarColor)
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Text(String(user.name.prefix(1)))
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                )
                                            
                                            Text(user.name)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                        .padding()
                                        .background(Color.gray.opacity(0.05))
                                        .cornerRadius(10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                // Create button
                Button(action: createChatRoom) {
                    Text("Create Chat")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(createButtonEnabled ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!createButtonEnabled)
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createHeader() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            Text(isGroup ? "New Group" : "New Chat")
                .font(.headline)
            
            Spacer()
            
            // Placeholder to balance the layout
            Circle()
                .fill(Color.clear)
                .frame(width: 32, height: 32)
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    private var createButtonEnabled: Bool {
        if isGroup {
            return !selectedParticipants.isEmpty
        } else {
            return selectedParticipants.count == 1
        }
    }
    
    private func isUserSelected(_ user: UserInfo) -> Bool {
        return selectedParticipants.contains(where: { $0.id == user.id })
    }
    
    private func addParticipant(_ user: UserInfo) {
        // If not a group chat, replace any existing selection
        if !isGroup {
            selectedParticipants = [user]
        } else {
            // For group chats, add to the selection if not already selected
            if !isUserSelected(user) {
                selectedParticipants.append(user)
            }
        }
    }
    
    private func removeParticipant(_ user: UserInfo) {
        selectedParticipants.removeAll(where: { $0.id == user.id })
    }
    
    private func createChatRoom() {
        // Extract participant IDs
        let participantIDs = selectedParticipants.map { $0.id }
        let participantNames = selectedParticipants.map { $0.name }
        
        let tempRoomName = roomName.trimmingCharacters(in: .whitespaces).isEmpty ? participantNames.joined(separator: ", ") : roomName
        
        if isGroup {
            // Create a group chat
            viewModel.createGroupChat(name: tempRoomName, participants: participantNames) { chatRoomID in
                if let chatRoomID = chatRoomID {
                    print("Successfully created group chat with ID: \(chatRoomID)")
                    // You might want to navigate to this chat room
                } else {
                    print("Failed to create group chat")
                }
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            // Create a private chat (1-on-1)
            if let participant = selectedParticipants.first {
                viewModel.createPrivateChat(with: participant.id, userName: participant.name) { chatRoomID in
                    if let chatRoomID = chatRoomID {
                        print("Successfully created private chat with ID: \(chatRoomID)")
                        // You might want to navigate to this chat room
                    } else {
                        print("Failed to create private chat")
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateChatRoomView(viewModel: AllChatsViewModel())
}
