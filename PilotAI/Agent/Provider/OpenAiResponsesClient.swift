import Foundation

public final class OpenAiResponsesClient: AgentProviderClient, Sendable {
    public init() {}

    public func stream(
        provider: ProviderSetting,
        model: Model,
        messages: [ProviderMessage],
        systemPrompt: String?,
        tools: [ProviderToolDefinition],
        effort: ReasoningEffort?,
        eventHandler: @escaping @Sendable (ProviderStreamEvent) -> Void
    ) async throws {
        // Fallback to OpenAI ChatCompletions stream logic for OpenAI responses API compatible endpoints
        let chatClient = OpenAiChatCompletionsClient()
        try await chatClient.stream(
            provider: provider,
            model: model,
            messages: messages,
            systemPrompt: systemPrompt,
            tools: tools,
            effort: effort,
            eventHandler: eventHandler
        )
    }
}
