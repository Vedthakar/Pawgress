//
//  LabeledTextField.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-13.
//

import SwiftUI

//MARK: Labelled text field for input
struct LabeledTextField: View {
    let label: String
    @Binding var text: String
    var isMandatory: Bool = false
    var charLimit: Int = 70
    var isPassword: Bool = false
    var isEmail: Bool = false
    
    @State private var isSecure: Bool = true // for toggling password visibility


//    private var hasValidationError: Bool {
//        viewModel.hasValidationError(text: text, isMandatory: isMandatory)
//    }
    
    // placeholder for password (grammar things)
    private var placeholder: String {
        if label.lowercased() == "confirm password" {
            return "Re-enter your password..."
        } else {
            return "Enter your \(label.lowercased())..."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            //TODO: Add error handling (i.e. char count)
            Text(label)
                .font(.Pixel(.callout).bold())
                .foregroundStyle(Color.oliveGold)

            HStack {
                if isPassword {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                            .textContentType(.password)
                            .autocapitalization(.none)
                    } else {
                        TextField(placeholder, text: $text)
                            .textContentType(.password)
                            .autocapitalization(.none)
                    }
                    
                    Button(action: { isSecure.toggle() }) {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundStyle(Color.coralPink.opacity(0.7))
                    }
                }
                else {
                    TextField("Enter your \(label.lowercased())...", text: $text)
                        .keyboardType(isEmail ? .emailAddress : .default)
                       .textContentType(isEmail ? .emailAddress : .username)
                       .autocapitalization(isEmail ? .none : .sentences)
                       .disableAutocorrection(isEmail)
                    Image(systemName: "textformat")
                        .foregroundStyle(Color.coralPink.opacity(0.5))
                }
                
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.oliveGold.opacity(0.3), lineWidth: 1.5)
            )
            .onChange(of: text) {
                text = String(text.prefix(charLimit)) //Character limit
            }
            
        }
    }
}
