import Foundation
import SwiftData

@Model
public final class McpServerEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var url: String
    public var enabled: Bool
    public var protocolMode: String
    public var authorizationType: String
    public var toolsJson: String
    public var enabledToolNamesJson: String
    public var createdAt: Int64
    public var sortOrder: Int
    public var lastRefreshedAt: Int64?
    public var lastProtocolVersion: String?
    public var toolsExpireAt: Int64?

    public init(
        id: String = UUID().uuidString,
        name: String,
        url: String,
        enabled: Bool = true,
        protocolMode: String = "auto",
        authorizationType: String = "none",
        toolsJson: String = "[]",
        enabledToolNamesJson: String = "[]",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        sortOrder: Int = 0,
        lastRefreshedAt: Int64? = nil,
        lastProtocolVersion: String? = nil,
        toolsExpireAt: Int64? = nil
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.enabled = enabled
        self.protocolMode = protocolMode
        self.authorizationType = authorizationType
        self.toolsJson = toolsJson
        self.enabledToolNamesJson = enabledToolNamesJson
        self.createdAt = createdAt
        self.sortOrder = sortOrder
        self.lastRefreshedAt = lastRefreshedAt
        self.lastProtocolVersion = lastProtocolVersion
        self.toolsExpireAt = toolsExpireAt
    }
}
