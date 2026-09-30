//
//  Friend.swift
//  Day61Challenge
//

import Foundation

// Kept Friend as a small Codable value type.
struct Friend: Codable, Hashable {
    var id: UUID
    var name: String
}
