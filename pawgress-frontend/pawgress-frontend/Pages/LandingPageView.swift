//
//  LandingPage.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct LandingPage: View {
    @State private var navigateToLogin = false
    @State private var navigateToRegister = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()

                    Image(.pawgressLogo)
                        .resizable()
                        .frame(width: 250, height: 250)

                    Spacer()
                    AnimatedTextView()
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    TextBtn(action: { navigateToLogin = true }, text: "Get Started")

                    Button("Create an Account") {
                        navigateToRegister = true
                    }
                    .font(.DMSans(.body))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.coralPink)
                    .padding(.bottom, 16)
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginPageView()
                    .navigationBarBackButtonHidden(true)
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterPageView()
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


private struct AnimatedTextView: View {
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
