//
//  ChatBubbleShape.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct ChatBubbleShape: Shape {
    var isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 20
        
        let corners: UIRectCorner = isFromCurrentUser
            ? [.topLeft, .topRight, .bottomLeft]
            : [.topRight, .bottomRight, .bottomLeft]
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        return Path(path.cgPath)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Left
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 200, height: 40)
            .clipShape(ChatBubbleShape(isFromCurrentUser: false))
        
        // Right
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 40)
            .clipShape(ChatBubbleShape(isFromCurrentUser: true))
    }
    .padding(30)
}
