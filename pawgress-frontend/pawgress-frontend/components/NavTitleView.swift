//
//  NavTitleView.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI


struct NavTitleView: View {
    var text: String = "hey, how are you?"
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.pawgressElbem)
                    .resizable()
                    .frame(width: 50, height: 50)
                
                Text("pawgress")
                    .font(.PixelS(40))
                    .foregroundColor(Color.coralPink)
            }
            
            Text(text)
                .padding(.horizontal, 3)
                .font(.DMSans(.caption2))
                .foregroundColor(Color.oliveGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 35)
        .fontWeight(.semibold)
    }
}

#Preview {
    NavTitleView()
}
