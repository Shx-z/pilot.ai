import Foundation

public struct ProviderToolDefinition: Codable, Sendable {
    public let name: String
    public let description: String
    public let inputSchemaJson: String

    public init(name: String, description: String, inputSchemaJson: String) {
        self.name = name
        self.description = description
        self.inputSchemaJson = inputSchemaJson
    }
}

public struct ProviderMessage: Codable, Sendable {
    public let role: String
    public let content: String
    public let toolCallId: String?
    public let name: String?

    public init(role: String, content: String, toolCallId: String? = nil, name: String? = nil) {
        self.role = role
        self.content = content
        self.toolCallId = toolCallId
        self.name = name
    }
}

public struct ProviderToolCall: Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let argumentsJson: String

    public init(id: String, name: String, argumentsJson: String) {
        self.id = id
        self.name = name
        self.argumentsJson = argumentsJson
    }
}

public enum ProviderStreamEvent: Sendable {
    case reasoningDelta(String)
    case textDelta(String)
    case toolCallDelta(id: String, name: String, argsDelta: String)
    case completed(toolCalls: [ProviderToolCall], usage: ProviderUsage?)
    case failed(Error)
}

public struct ProviderUsage: Codable, Sendable {
    public let inputTokens: Int?
    public let outputTokens: Int?
    public let reasoningTokens: Int?

    public init(inputTokens: Int? = nil, outputTokens: Int? = nil, reasoningTokens: Int? = nil) {
        self.inputTokens = inputTokens
        self.outputTokens = outputTokens
        self.reasoningTokens = reasoningTokens
    }
}

public protocol AgentProviderClient: Sendable {
    func stream(
        provider: ProviderSetting,
        model: Model,
        messages: [ProviderMessage],
        systemPrompt: String?,
        tools: [ProviderToolDefinition],
        effort: ReasoningEffort?,
        eventHandler: @escaping @Sendable (ProviderStreamEvent) -> Void
    ) async throws
}
