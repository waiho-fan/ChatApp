//
//  MessageInputView.swift
//  ChatApps
//
//  Created by Gary on 3/3/2025.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    var onSend: () -> Void
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Attach File
                Button(action: {
                    isShowingImagePicker = true
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
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
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

#Preview {
    @Previewable @State var messageText: String = ""
    MessageInputView(messageText: $messageText, onSend: {})
}
