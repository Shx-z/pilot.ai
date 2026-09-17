import Foundation

public struct McpProtocolMode {
    public static let auto = "auto"
    public static let latest = "2026-07-28"
    public static let legacy = "2025-11-25"
}

public struct McpAuthorizationType {
    public static let none = "none"
    public static let bearer = "bearer"
}

public struct McpToolDefinition: Codable, Identifiable, Hashable, Sendable {
    public var id: String { name }
    public let name: String
    public let title: String
    public let description: String
    public let inputSchemaJson: String
    public let readOnlyHint: Bool?
    public let destructiveHint: Bool?
    public let idempotentHint: Bool?
    public let openWorldHint: Bool?

    public init(
        name: String,
        title: String = "",
        description: String = "",
        inputSchemaJson: String,
        readOnlyHint: Bool? = nil,
        destructiveHint: Bool? = nil,
        idempotentHint: Bool? = nil,
        openWorldHint: Bool? = nil
    ) {
        self.name = name
        self.title = title
        self.description = description
        self.inputSchemaJson = inputSchemaJson
        self.readOnlyHint = readOnlyHint
        self.destructiveHint = destructiveHint
        self.idempotentHint = idempotentHint
        self.openWorldHint = openWorldHint
    }
}

public struct McpServerSetting: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let url: String
    public let enabled: Bool
    public let protocolMode: String
    public let authorizationType: String
    public let tools: [McpToolDefinition]
    public let enabledToolNames: Set<String>
    public let createdAt: Int64
    public let sortOrder: Int
    public let lastRefreshedAt: Int64?
    public let lastProtocolVersion: String?
    public let toolsExpireAt: Int64?

    public init(
        id: String,
        name: String,
        url: String,
        enabled: Bool = true,
        protocolMode: String = McpProtocolMode.auto,
        authorizationType: String = McpAuthorizationType.none,
        tools: [McpToolDefinition] = [],
        enabledToolNames: Set<String> = [],
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
        self.tools = tools
        self.enabledToolNames = enabledToolNames
        self.createdAt = createdAt
        self.sortOrder = sortOrder
        self.lastRefreshedAt = lastRefreshedAt
        self.lastProtocolVersion = lastProtocolVersion
        self.toolsExpireAt = toolsExpireAt
    }

    public var activeTools: [McpToolDefinition] {
        guard enabled else { return [] }
        return tools.filter { enabledToolNames.contains($0.name) }
    }
}
