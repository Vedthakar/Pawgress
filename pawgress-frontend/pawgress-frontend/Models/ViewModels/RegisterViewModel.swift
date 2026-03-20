//
//  LoginViewModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//


import Foundation

enum FocusedFieldL: Hashable {
    case email, username, password, passwordConfirm
}

enum FieldType: Hashable {
    case email, username, password
}

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isChecked: Bool = false

    @Published var emailError: String? = nil
    @Published var usernameError: String? = nil
    @Published var passwordError: String? = nil
    @Published var checkboxError: String? = nil
    @Published var error: String? = nil

    var passwordsMatch: Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirm = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedPassword.isEmpty && trimmedPassword == trimmedConfirm
    }

    var emailIsValid: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
    }

    var usernameIsValid: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @discardableResult
    func validatePasswords() -> Bool {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirm = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedPassword.isEmpty || trimmedConfirm.isEmpty {
            passwordError = "Password cannot be empty"
            return false
        } else if trimmedPassword != trimmedConfirm {
            passwordError = "Passwords do not match"
            return false
        } else {
            passwordError = nil
            return true
        }
    }

    @discardableResult
    func validateEmail() -> Bool {
        if !emailIsValid || email.isEmpty {
            emailError = "Invalid email"
            return false
        }
        emailError = nil
        return true
    }

    @discardableResult
    func validateUsername() -> Bool {
        if !usernameIsValid || username.isEmpty {
            usernameError = "Username must be nonempty"
            return false
        }
        usernameError = nil
        return true
    }

    @discardableResult
    func validateCheckbox() -> Bool {
        if !isChecked {
            checkboxError = "Take care of your pet!"
            return false
        }
        checkboxError = nil
        return true
    }

    @discardableResult
    func validateRegister() -> Bool {
        let passwordsValid = validatePasswords()
        let emailValid = validateEmail()
        let usernameValid = validateUsername()
        let checkboxValid = validateCheckbox()

        return passwordsValid && emailValid && usernameValid && checkboxValid
    }

    func validateAll() -> Bool {
        validatePasswords()
        validateEmail()
        validateUsername()
        validateCheckbox()
        return  emailError == nil &&
                passwordError == nil &&
                usernameError == nil &&
                checkboxError == nil
    }

    func registerUser() async throws -> RegistrationModel {
        let url = try APIConfig.url(path: "/api/register/")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newUser = RegisterRequest(
            email: email,
            name: username,
            password: password,
            password2: confirmPassword,
            tc: isChecked
        )

        request.httpBody = try JSONEncoder().encode(newUser)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if (200...299).contains(httpResponse.statusCode) {
            error = nil
            return try JSONDecoder().decode(RegistrationModel.self, from: data)
        }

        let message = String(data: data, encoding: .utf8) ?? "Unknown error"
        error = message
        throw NSError(
            domain: "",
            code: httpResponse.statusCode,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
    }
}
