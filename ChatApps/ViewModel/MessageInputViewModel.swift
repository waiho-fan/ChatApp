//
//  MessageInputViewModel.swift
//  ChatApps
//
//  Created by Gary on 6/3/2025.
//

import FirebaseStorage
import SwiftUI

class MessageInputViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var isShowingImagePicker: Bool = false
    @Published var isUploading: Bool = false
    @Published var uploadProgress: Float = 0
    
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
    
    func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
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
