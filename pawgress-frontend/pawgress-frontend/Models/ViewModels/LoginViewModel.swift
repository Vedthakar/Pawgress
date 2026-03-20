//
//  LoginViewModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-13.
//
import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String? = nil

    func loginUser() async throws -> RegistrationModel {
        let url = try APIConfig.url(path: "/api/login/")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let user = LoginRequest(
            email: email,
            password: password
        )

        request.httpBody = try JSONEncoder().encode(user)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if (200...299).contains(httpResponse.statusCode) {
            error = nil
            return try JSONDecoder().decode(RegistrationModel.self, from: data)
        }

        struct APIErrorResponse: Decodable {
            struct ErrorDetail: Decodable {
                let non_field_errors: [String]?
            }

            let errors: ErrorDetail?
        }

        let decodedError = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
        let errorMsg = decodedError?.errors?.non_field_errors?.first
            ?? String(data: data, encoding: .utf8)
            ?? "Unknown error"

        error = errorMsg
        throw NSError(
            domain: "",
            code: httpResponse.statusCode,
            userInfo: [NSLocalizedDescriptionKey: errorMsg]
        )
    }
}
