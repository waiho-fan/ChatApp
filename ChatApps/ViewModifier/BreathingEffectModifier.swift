//
//  BreathingEffectModifier.swift
//  ChatApps
//
//  Created by Gary on 15/3/2025.
//

import Foundation
import SwiftUI

struct BreathingEffectModifier: ViewModifier {
    // 控制呼吸效果的屬性
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.5
    
    // 自定義參數
    var color: Color = .blue
    var minOpacity: Double = 0.5
    var maxOpacity: Double = 1.0
    var minScale: CGFloat = 1.0
    var maxScale: CGFloat = 1.05
    var animationDuration: Double = 3
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .blendMode(.overlay)
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 2)
                    .shadow(color: color.opacity(opacity), radius: 10, x: 0, y: 0)
                    .scaleEffect(scale)
            )
            .onAppear {
                // 呼吸效果動畫 - 同時變化不透明度和縮放
                withAnimation(
                    .easeInOut(duration: animationDuration / 2)
                    .repeatForever(autoreverses: true)
                ) {
                    opacity = maxOpacity
                    scale = maxScale
                }
            }
    }
}

extension View {
    func breathingEffect(
        color: Color = .blue,
        minOpacity: Double = 0.5,
        maxOpacity: Double = 1.0,
        minScale: CGFloat = 1.0,
        maxScale: CGFloat = 1.05,
        animationDuration: Double = 3
    ) -> some View {
        self.modifier(
            BreathingEffectModifier(
                color: color,
                minOpacity: minOpacity,
                maxOpacity: maxOpacity,
                minScale: minScale,
                maxScale: maxScale,
                animationDuration: animationDuration
            )
        )
    }
}

#Preview {
    Text("Breath Effect")
        .font(.title)
        .padding(20)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(16)
        .breathingEffect(
            color: .blue,
            minOpacity: 0.4,
            maxOpacity: 0.9,
            minScale: 1.0,
            maxScale: 1.03,
            animationDuration: 4
        )
}
