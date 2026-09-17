import Foundation
import SwiftData

@Model
public final class ProviderEntity {
    @Attribute(.unique) public var id: String
    public var name: String
    public var baseUrl: String
    public var type: String
    public var sourceType: String
    public var apiKey: String
    public var isEnabled: Bool
    public var isBuiltIn: Bool
    public var sortOrder: Int
    public var systemPrompt: String?
    public var endpointMode: String
    public var anthropicVersion: String
    public var hostedWebSearchEnabled: Bool
    public var customHeadersJson: String
    public var customBodyJson: String
    public var createdAt: Int64

    public init(
        id: String,
        name: String,
        baseUrl: String,
        type: String,
        sourceType: String = "custom",
        apiKey: String = "",
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        sortOrder: Int = 0,
        systemPrompt: String? = nil,
        endpointMode: String = "chat_completions",
        anthropicVersion: String = "2023-06-01",
        hostedWebSearchEnabled: Bool = false,
        customHeadersJson: String = "[]",
        customBodyJson: String = "[]",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl
        self.type = type
        self.sourceType = sourceType
        self.apiKey = apiKey
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.sortOrder = sortOrder
        self.systemPrompt = systemPrompt
        self.endpointMode = endpointMode
        self.anthropicVersion = anthropicVersion
        self.hostedWebSearchEnabled = hostedWebSearchEnabled
        self.customHeadersJson = customHeadersJson
        self.customBodyJson = customBodyJson
        self.createdAt = createdAt
    }
}
