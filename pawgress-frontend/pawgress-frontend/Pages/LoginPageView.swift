//
//  LoginPageView.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct LoginPageView: View {
    @StateObject private var loginVM = LoginViewModel()
    @State private var navigateToHome = false
    @State private var navigateToRegister = false
    
    var body: some View {
        ScrollView {
            Spacer()
            Text("Login")
                .font(.PixelS(30).bold())
                .foregroundStyle(Color.oliveGold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            
            VStack(spacing: 30) {
                //Login
                VStack(spacing: 10) {
                    LabeledTextField(label: "email", text: $loginVM.email, isEmail: true)
                    
                    LabeledTextField(label: "password", text: $loginVM.password, isPassword: true)
                    
                    if let error = loginVM.error {
                        ErrorMessage(label:error)
                    }
                    
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.ivoryWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.coralPink, lineWidth: 2)
                        )
                )
                .padding(.horizontal, 25)
                
                
                TextBtn(action: {
                    Task {
                        do {
                            _ = try await loginVM.loginUser()
                            navigateToHome = true
                        } catch {
                            loginVM.error = error.localizedDescription
                        }
                    }
                }
                , text: "Login")
                
                Button("Create an Account") {
                    navigateToRegister = true
                }
                .font(.DMSans(.body))
                .fontWeight(.bold)
                .foregroundStyle(Color.coralPink)

            }
            
        }
        .scrollDismissesKeyboard(.interactively)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.lightCream
                .ignoresSafeArea()
        )
        .safeAreaInset(edge: .top) {
            NavTitleView()
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToHome) {
            HomePageView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $navigateToRegister) {
            RegisterPageView()
        }
    }
}

#Preview {
    LoginPageView()
}
