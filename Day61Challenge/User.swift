//
//  User.swift
//  Day61Challenge
//

import Foundation
import SwiftData

// Converted User into a SwiftData @Model class with manual Codable support.
@Model
// final prevents another class from inheriting from User.
// That keeps the SwiftData model’s structure predictable.
// Codable means User conforms to both decodable and encodble.
// That allows the app to create users from JSON and could (but
// we don't in this app) convert users back to JSON
final class User: Codable {
    
    // The .unique option tells SwiftData that two stored User
    // records should not have the same id. This is especially
    // useful when downloading the same data more than once: the
    // UUID provides a stable way to identify a particular user.
    // This identifier is separate from SwiftData’s internal
    // persistent identity. It is an identifier supplied by
    // the app’s data source (the JSON Internet file).
    @Attribute(.unique)
    var id: UUID
    // None of these properties is optional. Consequently, all
    // corresponding values must be present and valid when decoding
    // a user. If, for example, the JSON does not contain email,
    // decoding will fail.
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var about: String
    var registered: Date
    var tags: [String]

    // Stored [Friend] using @Attribute(.codable).
    // The .codable attribute tells SwiftData to persist the
    // array as a codable value.
    // An important distinction is that Friend is not a
    // SwiftData @Model. Therefore, these friends are stored as
    // values inside the user record rather than as separately
    // managed SwiftData objects.

    // That means:

    // • Each User owns its own [Friend] value.
    // • A friend is not independently insertable or deletable
    // through ModelContext.
    // • SwiftData does not treat this property as a relationship
    // between model objects.
    // • If richer friend querying or shared friend objects were
    // needed, Friend could instead become an @Model with a
    // SwiftData relationship.

    
    @Attribute(.codable)
    var friends: [Friend]

    
    init(
        id: UUID,
        isActive: Bool,
        name: String,
        age: Int,
        company: String,
        email: String,
        about: String,
        registered: Date,
        tags: [String],
        friends: [Friend]
    ) {
        self.id = id
        self.isActive = isActive
        self.name = name
        self.age = age
        self.company = company
        self.email = email
        self.about = about
        self.registered = registered
        self.tags = tags
        self.friends = friends
    }

    // CodingKeys defines the keys used during encoding and
    // decoding.
    enum CodingKeys: String, CodingKey {
        case id
        case isActive
        case name
        case age
        case company
        case email
        case about
        case registered
        case tags
        case friends
    }

    // This initializer satisfies the Decodable requirement.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

    //The decoder receives encoded data and creates a keyed
    // container. A keyed container behaves somewhat like a
    // dictionary whose allowed keys are the cases in CodingKeys.
    // Each property is then decoded:
        
    // The first argument tells the decoder which Swift type
    // to expect. The second argument identifies the source key.
        id = try container.decode(UUID.self, forKey: .id)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        name = try container.decode(String.self, forKey: .name)
        
        // For example, this statement means “Read the value stored
        // under "age" and require it to be an Int.”
        age = try container.decode(Int.self, forKey: .age)
        company = try container.decode(String.self, forKey: .company)
        email = try container.decode(String.self, forKey: .email)
        about = try container.decode(String.self, forKey: .about)
        registered = try container.decode(Date.self, forKey: .registered)
        tags = try container.decode([String].self, forKey: .tags)
        
        // Since Friend conforms to Decodable through Codable, the
        // decoder can recursively decode every friend in the array.
        friends = try container.decode([Friend].self, forKey: .friends)
    }

    // This method satisfies the Encodable requirement.
    // We do not do any encoding in this app.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(about, forKey: .about)
        try container.encode(registered, forKey: .registered)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}
