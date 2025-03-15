//
//  NeonBorderModifier.swift
//  ChatApps
//
//  Created by Gary on 15/3/2025.
//

import Foundation
import SwiftUI

struct NeonBorderModifier: ViewModifier {
    // 控制顏色變化的屬性
    @State private var hueRotation: Double = 0
    @State private var intensity: Double = 0.8
    
    // 自定義參數
    var color: Color = .blue
    var width: CGFloat = 3
    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 10
    var colorCycling: Bool = true
    var pulseEffect: Bool = true
    var animationDuration: Double = 3
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color.opacity(intensity), lineWidth: width)
                    .shadow(color: color.opacity(intensity * 0.7), radius: shadowRadius)
                    .hueRotation(.degrees(colorCycling ? hueRotation : 0))
            )
            .onAppear {
                // 顏色循環動畫
                if colorCycling {
                    withAnimation(
                        .linear(duration: animationDuration)
                        .repeatForever(autoreverses: false)
                    ) {
                        hueRotation = 360
                    }
                }
                
                // 脈衝亮度動畫
                if pulseEffect {
                    withAnimation(
                        .easeInOut(duration: animationDuration / 2)
                        .repeatForever(autoreverses: true)
                    ) {
                        intensity = 1.0
                    }
                }
            }
    }
}

// 為 View 添加擴展方法
extension View {
    func neonBorder(
        color: Color = .blue,
        width: CGFloat = 3,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 10,
        colorCycling: Bool = true,
        pulseEffect: Bool = true,
        animationDuration: Double = 3
    ) -> some View {
        self.modifier(
            NeonBorderModifier(
                color: color,
                width: width,
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                colorCycling: colorCycling,
                pulseEffect: pulseEffect,
                animationDuration: animationDuration
            )
        )
    }
}

#Preview {
    Text("Neon Border")
        .font(.title)
        .padding(20)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(16)
        .neonBorder(
            color: .blue,
            width: 2,
            cornerRadius: 16,
            shadowRadius: 8,
            colorCycling: false,
            pulseEffect: true
        )
}
