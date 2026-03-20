//
//  Icon Button.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-14.
//


import SwiftUI

struct IconButton: View {
    var action: () -> Void
    var text: String = "None"
    var image: UIImage = .pawgressLogo
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 2) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Text(text)
            }
        }
        .font(.PixelS(18))
        .fontWeight(.heavy)
        .padding(10)
        .frame(width: 160, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.ivoryWhite.opacity(0.8))
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.coralPink, lineWidth: 2)
                }
        }
        .foregroundColor(.black)
        .padding(10)
    }
}

#Preview {
    IconButton(action: {})
}
