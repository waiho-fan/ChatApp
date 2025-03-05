//
//  MessageInputView.swift
//  ChatApps
//
//  Created by Gary on 3/3/2025.
//

import SwiftUI

struct MessageInputView: View {
    @StateObject var viewModel = MessageInputViewModel()
    @Binding var messageText: String

    var onSend: () -> Void
    var onSendImages: (_ imageURLs: [String]) -> Void

    var body: some View {
        VStack(spacing: 0) {
            
            // Selected Image Preview
            if !viewModel.selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<viewModel.selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: viewModel.selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                // Remove button
                                Button(action: {
                                    viewModel.selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding(4)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color.gray.opacity(0.1))
            }
            
            // Upload Progress view
            if viewModel.isUploading {
                ProgressView(value: viewModel.uploadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            
            Divider()
            
            HStack(spacing: 12) {
                // Attach File
                Button(action: {
                    viewModel.isShowingImagePicker = true
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
                .sheet(isPresented: $viewModel.isShowingImagePicker) {
                    ImagePicker(selectedImages: $viewModel.selectedImages)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                        .presentationBackgroundInteraction(.enabled)
                        .presentationCornerRadius(25)
                        .interactiveDismissDisabled(false)
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
                Button(action: {
                    if !viewModel.selectedImages.isEmpty {
                        viewModel.isUploading = true
                        viewModel.uploadImages(viewModel.selectedImages) { imageURLs in
                            viewModel.isUploading = false
                            if !imageURLs.isEmpty {
                                onSendImages(imageURLs)
                                viewModel.selectedImages.removeAll()
                            }
                        }
                    } else if !messageText.trimmingCharacters(in: .whitespaces).isEmpty {
                        // Send text message
                        onSend()
                    }
                }) {
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
    @Previewable @State var selectedImages: [UIImage] = []
    MessageInputView(messageText: $messageText,
                     onSend: {},
                     onSendImages: {imageURLs in }
                     )
}
