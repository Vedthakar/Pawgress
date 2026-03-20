//
//  UserModel.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import Foundation


struct User: Codable, Identifiable {
    var id: String?
    var name: String
    var email: String

    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
