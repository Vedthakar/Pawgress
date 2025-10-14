//
//  LoginPageView.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct LoginPageView: View {
    //    @State private var email: String = ""
    //    @State private var username: String = ""
    //    @State private var password: String = ""
    //    @State private var confirmPassword: String = ""
    //    @State private var isChecked: Bool = false
    @ObservedObject private var loginVM = LoginViewModel()
    
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
                    print(loginVM.email)
                    print(loginVM.password)
                    // First validate all fields
                    //TODO: Move ts shit
                    Task {
                        do {
                            let result = try await loginVM.loginUser()
                            print("Registration success:", result.msg)
                        } catch {
                            print("Registration failed:", error.localizedDescription)
                        }
                    }
                }
                , text: "Login")
                
                Text("Want to register?")

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
    }
}

#Preview {
    LoginPageView()
}
