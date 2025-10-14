//
//  LoginPageView.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

struct RegisterPageView: View {
//    @State private var email: String = ""
//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    @State private var isChecked: Bool = false
    @ObservedObject private var registerVM = RegisterViewModel()

    var body: some View {
        ScrollView {
            Spacer()
            Text("Register")
                .font(.PixelS(30).bold())
                .foregroundStyle(Color.oliveGold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)

            VStack(spacing: 30) {
                //Login
                VStack(spacing: 10) {
                    LabeledTextField(label: "email", text: $registerVM.email, isEmail: true)
                        .onChange(of: registerVM.email) {
                            registerVM.validateEmail()
                        }
                    
                    if let emailError = registerVM.emailError {
                        ErrorMessage(label:emailError)
                    }
                    
                    LabeledTextField(label: "username", text: $registerVM.username)
                        .onChange(of: registerVM.username) {
                            registerVM.validateUsername()
                        }
                    
                    if let usernameError = registerVM.usernameError {
                        ErrorMessage(label:usernameError)
                    }
                    
                    LabeledTextField(label: "password", text: $registerVM.password, isPassword: true)
                        .onChange(of: registerVM.password) {
                            registerVM.validatePasswords()
                        }
                    
                    LabeledTextField(label: "confirm password", text: $registerVM.confirmPassword, isPassword: true)
                        .onChange(of: registerVM.confirmPassword) {
                            registerVM.validatePasswords()
                        }
                    
                    if let passwordError = registerVM.passwordError {
                        ErrorMessage(label:passwordError)
                    }
                    
                    
                    Toggle(isOn: $registerVM.isChecked) {
                        Text("I agree to take care of my pet!")
                            .font(.DMSans(.callout).bold())
                    }
                    .onChange(of: registerVM.isChecked) {
                        registerVM.validateCheckbox()
                    }
                    .toggleStyle(CheckboxToggleStyle(activeColor: Color.coralPink, labelColor: Color.oliveGold))
                    
                    if let checkboxError = registerVM.checkboxError {
                        ErrorMessage(label:checkboxError)
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
                    // First validate all fields
                    //TODO: Move ts shit
                    registerVM.printVal()
                    if registerVM.validateAll() {
                        Task {
                            do {
                                let result = try await registerVM.registerUser()
                                print("Registration success:", result.msg)
                            } catch {
                                print("Registration failed:", error.localizedDescription)
                            }
                        }
                    } else {
                        print("Validation failed")
                    }
                }, text: "Register")

                Text("Want to sign in?")
                
                
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
    RegisterPageView()
}
