//
//  User.swift
//  Day61Challenge
//

import Foundation

struct User: Codable, Hashable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}
