//
//  LightTracingBorderEffect.swift
//  ChatApps
//
//  Created by Gary on 15/3/2025.
//

import Foundation
import SwiftUI

struct LightTracingBorderModifier: ViewModifier {
    @State private var trimEnd: CGFloat = 0
    @State private var rotation: Angle = .degrees(0)
    var duration: Double = 2.0
    var lineWidth: CGFloat = 1
    var cornerRadius: CGFloat = 12
    var lightColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    // 底層虛線邊框
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: [2, 4]
                        ))
                        .foregroundColor(.white.opacity(0.3))
                    
                    // 追蹤光點效果
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .trim(from: trimEnd - 0.05, to: trimEnd)
                        .stroke(
                            lightColor,
                            style: StrokeStyle(
                                lineWidth: lineWidth + 0.5,
                                lineCap: .round
                            )
                        )
                }
            )
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    // 讓光點圍繞邊框旋轉
                    self.trimEnd = 1.0
                }
            }
    }
}

extension View {
    func lightTracingBorder(
        duration: Double = 2.0,
        lineWidth: CGFloat = 1,
        cornerRadius: CGFloat = 12,
        lightColor: Color = .white
    ) -> some View {
        self.modifier(LightTracingBorderModifier(
            duration: duration,
            lineWidth: lineWidth,
            cornerRadius: cornerRadius,
            lightColor: lightColor
        ))
    }
}

#Preview {
    Text("Light Tracing Border")
        .font(.title)
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(12)
        .lightTracingBorder(duration: 5, lineWidth: 3)
        .padding()
}
