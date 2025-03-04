//
//  ImagePicker.swift
//  ChatApps
//
//  Created by iOS Dev Ninja on 2/3/2025.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 3
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.presentationMode.wrappedValue.dismiss()
        
        if results.isEmpty {
            return
        }
        
        parent.selectedImages.removeAll()
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

extension UIImage {
    static func sampleURL() -> String {
        "https://cdn.leonardo.ai/users/a61b9ad5-4db4-4761-90b1-0049aeced747/generations/fd79a5a6-4717-4615-a396-35d57654437c/Leonardo_Anime_XL_full_body_portraitlight_in_the_eyes_shining_3.jpg?w=512"
    }
    
    static func sampleURLs() -> [String] {
        [
            "https://cdn.leonardo.ai/users/a61b9ad5-4db4-4761-90b1-0049aeced747/generations/fd79a5a6-4717-4615-a396-35d57654437c/Leonardo_Anime_XL_full_body_portraitlight_in_the_eyes_shining_3.jpg?w=512",
            "https://cdn.leonardo.ai/users/e73df620-765c-47fd-ac9e-e7fff90d51bc/generations/f63a43c0-93d6-4f6e-9c6c-410c8fa48c4e/Leonardo_Phoenix_10_7_Pouring_Milk_Tea_into_a_GlassPromptA_chu_0.jpg?w=512",
            "https://cdn.leonardo.ai/users/faba8a63-6f34-4537-83d5-415a3db43258/generations/4609bb6d-889b-4fda-be6e-63ec77faba56/Leonardo_Phoenix_10_Dynamic_oil_painting_in_the_style_of_Alyss_0.jpg?w=512"
        ]
    }
}
