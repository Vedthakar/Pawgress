//
//  ErrorMessage.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-11.
//

import SwiftUI

struct ErrorMessage: View {
    let label: String
    let color: Color = Color.red
    var body: some View {
        Text(label)
            .font(.DMSansS(10))
            .foregroundStyle(color.opacity(0.6))
    }
}

struct PercentageMessage: View {
    let value: Double
    let color: Color = Color.coralPink
    var body: some View {
        Text("\(Int(value * 100))%")
            .fontWeight(.heavy)
            .font(.DMSans(.title))
            .foregroundStyle(color)
    }
   
}


struct TypewriterText: View {
    let text: String
    let speed: Double //second per char
    
    @State private var displayedText: String = ""
    
    var body: some View {
        Text(displayedText)
            .onAppear {
                typeWriter()
            }
    }
    
    private func typeWriter(at position: Int = 0) {
        if position < text.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                displayedText.append(text[text.index(text.startIndex, offsetBy: position)])
                typeWriter(at: position + 1)
            }
        }
    }
}
