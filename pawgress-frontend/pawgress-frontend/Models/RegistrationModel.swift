//
//  RegistrationModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-11.
//


struct RegisterRequest: Codable {
    let email: String
    let name: String
    let password: String
    let password2: String
    let tc: Bool
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct Token: Codable {
    let refresh: String
    let access: String
    
    enum CodingKeys: String, CodingKey {
        case refresh = "refresh"
        case access = "access"
       
    }
}

//MARK: Temp for testing
struct RegistrationModel: Codable {
    let token: Token
    let msg: String

    enum CodingKeys: String, CodingKey {
        case token = "token"
        case msg = "msg"
    }
    
   
}

    
