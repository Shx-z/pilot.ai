import Foundation

public actor AgentLoop {
    private let providerClient: AgentProviderClient
    private let controller: AgentRunController

    public init(
        providerClient: AgentProviderClient = OpenAiChatCompletionsClient(),
        controller: AgentRunController = AgentRunController()
    ) {
        self.providerClient = providerClient
        self.controller = controller
    }

    public func run(
        provider: ProviderSetting,
        model: Model,
        initialMessages: [ProviderMessage],
        systemPrompt: String?,
        tools: [ProviderToolDefinition],
        effort: ReasoningEffort?,
        toolExecutor: @Sendable (ProviderToolCall) async throws -> String,
        eventHandler: @escaping @Sendable (ProviderStreamEvent) -> Void
    ) async throws -> String {
        var messages = initialMessages
        var turnCount = 0
        let maxTurns = 10
        var fullAssistantResponse = ""

        while turnCount < maxTurns {
            turnCount += 1
            if await controller.isCancelled {
                eventHandler(.failed(NSError(domain: "AgentLoop", code: -1, userInfo: [NSLocalizedDescriptionKey: "Run cancelled by user"])))
                return fullAssistantResponse
            }

            // Pop steering instruction if present
            if let steering = await controller.popSteering() {
                messages.append(ProviderMessage(role: "user", content: "[Steering]: \(steering)"))
            }

            var toolCallsReceived: [ProviderToolCall] = []

            try await providerClient.stream(
                provider: provider,
                model: model,
                messages: messages,
                systemPrompt: systemPrompt,
                tools: tools,
                effort: effort
            ) { event in
                eventHandler(event)
                switch event {
                case .textDelta(let text):
                    fullAssistantResponse += text
                case .completed(let toolCalls, _):
                    toolCallsReceived = toolCalls
                default:
                    break
                }
            }

            if toolCallsReceived.isEmpty {
                // No further tool calls, loop completed
                break
            }

            // Append assistant tool call request to history
            messages.append(ProviderMessage(role: "assistant", content: fullAssistantResponse))

            // Execute tools serially
            for toolCall in toolCallsReceived {
                if await controller.isCancelled { break }
                let result = try await toolExecutor(toolCall)
                messages.append(ProviderMessage(role: "tool", content: result, toolCallId: toolCall.id, name: toolCall.name))
            }
        }

        return fullAssistantResponse
    }
}
