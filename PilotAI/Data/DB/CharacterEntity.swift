import Foundation
import SwiftData

@Model
public final class CharacterEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var cardJson: String
    public var avatarPath: String?
    public var archived: Bool
    public var createdAt: Int64
    public var updatedAt: Int64

    public init(
        id: String = UUID().uuidString,
        name: String,
        cardJson: String = "{}",
        avatarPath: String? = nil,
        archived: Bool = false,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.cardJson = cardJson
        self.avatarPath = avatarPath
        self.archived = archived
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
public final class UserPersonaEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var descriptionText: String

    public init(
        id: String = "main",
        name: String = "User",
        descriptionText: String = ""
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
    }
}
