//
//  MultiImageMessageView.swift
//  ChatApps
//
//  Created by Gary on 4/3/2025.
//

import SwiftUI

struct MultiImageMessageView: View {
    let imageURLs: [String]
    
    var body: some View {
        if imageURLs.count == 1 {
            ImageMessageView(url: imageURLs[0])
                .frame(maxWidth: 240, maxHeight: 300)
        } else if imageURLs.count == 2 {
            HStack(spacing: 2) {
                ForEach(imageURLs, id: \.self) { url in
                    ImageMessageView(url: url)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 240, maxHeight: 300)
                        .clipped()
                }
            }
            .frame(maxWidth: 240)
        } else if imageURLs.count == 3 {
            HStack(spacing: 4) {
                ImageMessageView(url: imageURLs[0])
                    .frame(maxWidth: 240, maxHeight: 300)

                VStack(spacing: 2) {
                    ForEach(imageURLs.dropFirst().prefix(2), id: \.self) { url in
                        ImageMessageView(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 119, maxHeight: 150)
                            .clipped()
                            .cornerRadius(4)
                    }
                }
            }
            .frame(maxWidth: 240)
        } else if imageURLs.count == 4 {
            // Image x4
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(Array(imageURLs.prefix(2).enumerated()), id: \.element) { _, url in
                        ImageMessageView(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 119, maxHeight: 120)
                            .clipped()
                    }
                }
                
                HStack(spacing: 2) {
                    ForEach(Array(imageURLs.dropFirst(2).prefix(2).enumerated()), id: \.element) { _, url in
                        ImageMessageView(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 119, maxHeight: 120)
                            .clipped()
                    }
                }
            }
            .frame(maxWidth: 240)
        } else {
            // Image 4+
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(Array(imageURLs.prefix(2).enumerated()), id: \.element) { _, url in
                        ImageMessageView(url: url)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 119, maxHeight: 120)
                            .clipped()
                    }
                }
                
                HStack(spacing: 2) {
                    ImageMessageView(url: imageURLs[2])
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 119, maxHeight: 120)
                        .clipped()
                    
                    ZStack {
                        ImageMessageView(url: imageURLs[3])
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 119, maxHeight: 120)
                            .clipped()
                            .overlay(Color.black.opacity(0.5))
                        
                        Text("+\(imageURLs.count - 4)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: 240)
        }
    }
}

struct ImageMessageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(minWidth: 60, minHeight: 60)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "photo")
                    .foregroundStyle(.gray)
                    .frame(minWidth: 60, minHeight: 60)
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(8)
    }
}

#Preview("Image x1", body: {
    let imageUrl = [UIImage.sampleURL()]
    MultiImageMessageView(imageURLs: imageUrl)
        .padding(4)
        .background(bgColor.opacity(0.3))
        .foregroundColor(.white)
        .clipShape(ChatBubbleShape(isFromCurrentUser: true))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
})

#Preview("Image x2", body: {
    let imageURLs = UIImage.sampleURLs()
    MultiImageMessageView(imageURLs: imageURLs.dropLast())
        .padding(4)
        .background(bgColor.opacity(0.3))
        .foregroundColor(.white)
        .clipShape(ChatBubbleShape(isFromCurrentUser: true))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
})

#Preview("Image x3", body: {
    let imageURLs = UIImage.sampleURLs()
    MultiImageMessageView(imageURLs: imageURLs)
        .padding(4)
        .background(bgColor.opacity(0.3))
        .foregroundColor(.white)
        .clipShape(ChatBubbleShape(isFromCurrentUser: true))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
})
