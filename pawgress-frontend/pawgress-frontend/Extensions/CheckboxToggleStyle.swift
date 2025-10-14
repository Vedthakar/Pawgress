//
//  CheckboxToggleStyle.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//


import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    var activeColor: Color = .coralPink
    var labelColor: Color = .primary
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(activeColor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        configuration.isOn.toggle()
                    }
                }
            
            configuration.label
                .foregroundStyle(labelColor)
            
            Spacer()
        }
        .contentShape(Rectangle()) 
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.15)) {
                configuration.isOn.toggle()
            }
        }
    }
}
