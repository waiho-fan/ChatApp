//
//  MessageInputView.swift
//  ChatApps
//
//  Created by Gary on 3/3/2025.
//

import FirebaseStorage
import SwiftUI

struct MessageInputView: View {
    @Binding var messageText: String
    @State private var selectedImages: [UIImage] = []
    @State private var isShowingImagePicker: Bool = false
    @State private var isUploading: Bool = false
    @State private var uploadProgress: Float = 0
    var onSend: () -> Void
    var onSendImages: (_ imageURLs: [String]) -> Void

    var body: some View {
        VStack(spacing: 0) {
            
            // Selected Image Preview
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                // Remove button
                                Button(action: {
                                    selectedImages.remove(at: index)
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
            if isUploading {
                ProgressView(value: uploadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            
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
                    ImagePicker(selectedImages: $selectedImages)
                        .presentationDetents([.height(300), .medium, .large])
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
                    if !selectedImages.isEmpty {
                        isUploading = true
                        uploadImages(selectedImages) { imageURLs in
                            isUploading = false
                            if !imageURLs.isEmpty {
                                onSendImages(imageURLs)
                                selectedImages.removeAll()
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
    
    private func uploadSingleImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            completion(nil)
            return
        }
        
        let filename = UUID().uuidString + ".jpg"
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("chatImages").child(filename)
        
        print("Upload to：\(imageRef)")
        // Upload image data
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Get download URL
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let downloadURL = url else {
                    print("Error: No download URL.")
                    completion(nil)
                    return
                }
                
                let imageURL = downloadURL.absoluteString
                print("Image uploaded successfully: \(imageURL)")
                completion(imageURL)
            }
        }
    }
    
    private func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var imageURLs: [String] = []
        let totalImages = images.count
        var completedUploads = 0
        
        for image in images {
            group.enter()
            
            uploadSingleImage(image) { url in
                if let url = url {
                    imageURLs.append(url)
                }
                
                completedUploads += 1
                self.uploadProgress = Float(completedUploads) / Float(totalImages)
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(imageURLs)
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
