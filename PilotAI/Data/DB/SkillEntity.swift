import Foundation
import SwiftData

@Model
public final class SkillEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var descriptionText: String
    public var location: String
    public var sourceUrl: String?
    public var isEnabled: Bool
    public var isBuiltIn: Bool
    public var promptContent: String
    public var createdAt: Int64

    public init(
        id: String = UUID().uuidString,
        name: String,
        descriptionText: String = "",
        location: String,
        sourceUrl: String? = nil,
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        promptContent: String = "",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.location = location
        self.sourceUrl = sourceUrl
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.promptContent = promptContent
        self.createdAt = createdAt
    }
}
