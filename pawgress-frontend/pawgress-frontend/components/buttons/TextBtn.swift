//
//  TextBtn.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct TextBtn: View {
    var action: () -> Void
    var text: String = "None"
    var body: some View {
        Button(text) {
            action()
        }
        .font(.DMSans(.title3))
        .fontWeight(.heavy)
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.ivoryWhite)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.coralPink, lineWidth: 2)
                )
        )
        .foregroundColor(.black)
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
}
