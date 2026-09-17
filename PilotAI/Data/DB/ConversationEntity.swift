import Foundation
import SwiftData

@Model
public final class ConversationEntity {
    @Attribute(.unique) public var id: String
    public var title: String
    public var thinkingEnabled: Bool
    public var reasoningEffort: String
    public var historyJson: String
    public var appliedRuntimeRunIdsJson: String
    public var roleplayJson: String
    public var revisionsJson: String
    public var createdAt: Int64
    public var updatedAt: Int64

    public init(
        id: String = UUID().uuidString,
        title: String = "New Chat",
        thinkingEnabled: Bool = false,
        reasoningEffort: String = "default",
        historyJson: String = "[]",
        appliedRuntimeRunIdsJson: String = "[]",
        roleplayJson: String = "",
        revisionsJson: String = "",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.title = title
        self.thinkingEnabled = thinkingEnabled
        self.reasoningEffort = reasoningEffort
        self.historyJson = historyJson
        self.appliedRuntimeRunIdsJson = appliedRuntimeRunIdsJson
        self.roleplayJson = roleplayJson
        self.revisionsJson = revisionsJson
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
