//
//  CustomImagePicker.swift
//  ChatApps
//
//  Created by Gary on 4/3/2025.
//

import SwiftUI
import PhotosUI

struct CustomImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            // 標題和關閉按鈕
            HStack {
                Text("選擇圖片")
                    .font(.headline)
                Spacer()
                Button("關閉") {
                    isShowing = false
                }
            }
            .padding()
            
            // 圖片選擇器
            PHPickerRepresentable(selectedImage: $selectedImage, isShowing: $isShowing)
                .frame(height: 250)
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
        .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 100)
        // 這裡的 y 值調整了選擇器在畫面上的位置
    }
}

// 使用 PHPicker 的包裝器
struct PHPickerRepresentable: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerRepresentable
        
        init(_ parent: PHPickerRepresentable) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                        self.parent.isShowing = false
                    }
                }
            } else {
                parent.isShowing = false
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedImage: UIImage?
    @Previewable @State var isShowing = false
    CustomImagePicker(selectedImage: $selectedImage, isShowing: $isShowing)
}
