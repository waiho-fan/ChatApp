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
    @Binding var selectedImage: UIImage?
    @State private var isShowingImagePicker: Bool = false
    var onSend: () -> Void
    var onSendImage: (_ imageURL: String) -> Void
    
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
                Button(action: {
                    if let image = selectedImage {
                        // Upload image & send message
                        uploadImageAndSendMessage(image) { imageURL in
                            if let imageURL = imageURL {
                                onSendImage(imageURL)
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
    
    private func uploadImageAndSendMessage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        
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
                
                // Reset
                self.selectedImage = nil
            }
        }
    }
}

#Preview {
    @Previewable @State var messageText: String = ""
    @Previewable @State var selectedImage: UIImage?
    MessageInputView(messageText: $messageText,
                     selectedImage: $selectedImage,
                     onSend: {},
                     onSendImage: {imageURL in  })
}
