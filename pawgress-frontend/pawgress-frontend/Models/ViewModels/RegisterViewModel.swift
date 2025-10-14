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

class RegisterViewModel: ObservableObject {

    // MARK: Input fields
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isChecked: Bool = false

    // MARK: Live error messages 
    @Published var emailError: String? = nil
    @Published var usernameError: String? = nil
    @Published var passwordError: String? = nil
    @Published var checkboxError: String? = nil

    // MARK: - Computed properties for UI-only
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

    // MARK: - Explicit validation
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
        if !usernameIsValid || username.isEmpty{
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
    
    //MARK: Debug
    func printVal() {
        //use model and then print
        let newUser = RegisterRequest(
            email: email,
            name: username,
            password: password,
            password2: confirmPassword,
            tc: isChecked
        )
        
        print(newUser)
        
    }

    // MARK: - Full registration validation
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
    
    //MARK: Fix and extend URL builder
    func registerUser() async throws -> RegistrationModel {
        guard let url = URL(string: "http://127.0.0.1:8000/api/login/") else { throw URLError(.badURL) }


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build the registration request
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
        if httpResponse.statusCode == 201 {
            // Only decode success response
//            print("hello it is 201!") -> does go here so wtaf is the issue AAAAAAAAAA
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            print(msg)
            let result = try JSONDecoder().decode(RegistrationModel.self, from: data)
            return result
        } else {
            // Just throw raw data as string for now
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }

    
//    func fetchMoviesFromAPI() async throws -> [Movie] {
//        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")!
//
//        let (data, _) = try await URLSession.shared.data(from: url)
//
//        let decoded = try JSONDecoder().decode(MoviesResponse.self, from: data)
//
//        return decoded.results
//    }
}
