//
//  ShimmerEffect.swift
//  ChatApps
//
//  Created by Gary on 15/3/2025.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    var duration: Double = 1.5
    var bounce: Bool = false

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        // 這個矩形會創建一個邊框
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        .white.opacity(0.2),
                                        .white.opacity(0.6),
                                        .white.opacity(0.2),
                                        .clear
                                    ]),
                                    startPoint: UnitPoint(x: phase, y: phase),
                                    endPoint: UnitPoint(x: phase + 1, y: phase + 1)
                                ),
                                lineWidth: 2
                            )
                    }
                    .mask(
                        // 確保動畫只發生在邊框上
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(lineWidth: 2)
                    )
                }
            )
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: duration)
                        .repeatForever(autoreverses: bounce)
                ) {
                    // 動畫會從 -0.5 到 1.5，這樣會讓它看起來像是環繞一圈
                    self.phase = 1.5
                }
            }
    }
}

extension View {
    func shimmerBorder(duration: Double = 1.5, bounce: Bool = false) -> some View {
        self.modifier(ShimmerModifier(duration: duration, bounce: bounce))
    }
}

struct ShimmerBorderModifier: ViewModifier {
    @State private var animationProgress: CGFloat = 0
    var duration: Double = 2.0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .clear, location: 0),
                                        .init(color: .clear, location: animationProgress - 0.1),
                                        .init(color: Color.white.opacity(0.8), location: animationProgress),
                                        .init(color: .clear, location: animationProgress + 0.1),
                                        .init(color: .clear, location: 1)
                                    ]),
                                    center: .center,
                                    startAngle: .degrees(-90),
                                    endAngle: .degrees(270)
                                ),
                                lineWidth: 3
                            )
                    }
                }
            )
            .onAppear {
                withAnimation(
                    Animation
                        .linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    // 旋轉一整圈
                    self.animationProgress = 1.0
                }
            }
    }
}

extension View {
    func shimmerBorderRotating(duration: Double = 2.0) -> some View {
        self.modifier(ShimmerBorderModifier(duration: duration))
    }
}

#Preview {
    Text("ShimmerBorderEffect")
        .padding()
        .font(.largeTitle)
        .background(.black)
        .foregroundStyle(.white)
        .cornerRadius(16)
        .shimmerBorder(duration: 2.0, bounce: true)
        .padding()
    Text("ShimmerBorderRotating")
        .padding()
        .font(.largeTitle)
        .background(.black)
        .foregroundStyle(.white)
        .cornerRadius(16)
        .shimmerBorderRotating(duration: 2.0)
        .padding()
}
