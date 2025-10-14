//
//  LoginViewModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-13.
//
import Foundation

class LoginViewModel: ObservableObject {
    // MARK: Input fields
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var error: String? = nil
    
    
    //MARK: Fix and extend URL builder
    func loginUser() async throws -> RegistrationModel {
        guard let url = URL(string: "http://127.0.0.1:8000//api/login/") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build the registration request
        let user = LoginRequest(
            email: email,
            password: password,
        )

        request.httpBody = try JSONEncoder().encode(user)

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
            //TODO: Clean ts shit so dirty
            //Decode error response temp struct
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
               
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])
//            // Just throw raw data as string for now
//            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
//            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }

    
}
