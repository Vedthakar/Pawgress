//
//  UserModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import Foundation


struct User: Codable, Identifiable {
    var id: String?            // Optional if creating a new user (server can generate)
    var name: String
    var email: String
        
    var password: String?      // Optional for security (might not return from API)
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case password = "password"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // Init for creating a new user
    init(name: String, email: String, password: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    // Optional: init from API JSON (if needed)
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decodeIfPresent(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.email = try container.decode(String.self, forKey: .email)
//        self.password = try container.decodeIfPresent(String.self, forKey: .password)
//        self.profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
//        
//        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
//            self.createdAt = ISO8601DateFormatter().date(from: createdAtString)
//        }
//        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
//            self.updatedAt = ISO8601DateFormatter().date(from: updatedAtString)
//        }
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(email, forKey: .email)
//        try container.encodeIfPresent(password, forKey: .password)
//        try container.encodeIfPresent(profileImageURL, forKey: .profileImageURL)
//        
//        if let createdAt = createdAt {
//            try container.encode(ISO8601DateFormatter().string(from: createdAt), forKey: .createdAt)
//        }
//        if let updatedAt = updatedAt {
//            try container.encode(ISO8601DateFormatter().string(from: updatedAt), forKey: .updatedAt)
//        }
//    }
}
