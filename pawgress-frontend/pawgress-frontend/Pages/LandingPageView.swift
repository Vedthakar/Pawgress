//
//  LandingPage.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct LandingPage: View {
    @State private var animate = false
    @State private var navigateToHome = false
    
    var body: some View {

        NavigationStack {
                   ZStack {
                       //MARK: Add background!
                   VStack(spacing: 20) {
                       Spacer()
                       Spacer()
                       
                       Image(.pawgressLogo)
                           .resizable()
                           .frame(width: 250, height: 250)
                           
                       Spacer()
                       //Animated text
                       AnimatedTextView(animate: $animate)
                       
                   }
               
               }
               .safeAreaInset(edge: .bottom) {
                   TextBtn(action: {navigateToHome = true}, text: "Get Started")
               }
               .navigationDestination(isPresented: $navigateToHome) {
                  LoginPageView()
                       .navigationBarBackButtonHidden(true)
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background(
                   Color.lightCream
                       .ignoresSafeArea()
               )
               .navigationBarHidden(true)
               }
    }
}



//MARK: Animated 'highlight' text
private struct AnimatedTextView: View {
    @Binding var animate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TypewriterText(text: "pawgress", speed: 0.30)
                .foregroundColor(Color.coralPink)
                .font(.PixelS(55))
                .fontWeight(.bold)
                
            Text("Pawgress, one paw at a time.")
                .font(.DMSansS(15))
                .fontWeight(.semibold)
                .foregroundColor(Color.oliveGold)
        }
        .padding(.horizontal, 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fontWeight(.semibold)
    }
}

#Preview {
    LandingPage()
}
