//
//  Color-Extension.swift
//  ChatApps
//
//  Created by Gary on 7/3/2025.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    static func randomNice() -> Color {
        let hue = Double.random(in: 0...1)
        let saturation = Double.random(in: 0.5...0.8)
        let brightness = Double.random(in: 0.7...0.9)
        
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    static func generateConsistentColor(from string: String) -> Color {
        // Use string to generate fixed color
        let hash = abs(string.hashValue)
        
        let red = Double((hash & 0xFF0000) >> 16) / 255.0
        let green = Double((hash & 0x00FF00) >> 8) / 255.0
        let blue = Double(hash & 0x0000FF) / 255.0
        
        // Be more bright
        let minBrightness: Double = 0.3
        let adjustedRed = max(red, minBrightness)
        let adjustedGreen = max(green, minBrightness)
        let adjustedBlue = max(blue, minBrightness)
        
        return Color(red: adjustedRed, green: adjustedGreen, blue: adjustedBlue)
    }
}
