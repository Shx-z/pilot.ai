import Foundation

public struct BuiltinProviders {
    public static let defaultSystemPrompt =
        "You are Pilot, an AI assistant running on iOS. You can answer questions, interact with the user, and use available tools to inspect context and perform actions. " +
        "Respond in the user's language, concisely, directly, and naturally."

    public static let openAIId = "builtin-openai"
    public static let anthropicId = "builtin-anthropic"
    public static let bailianId = "builtin-dashscope"
    public static let deepSeekId = "builtin-deepseek"
    public static let kimiId = "builtin-kimi"
    public static let mimoId = "builtin-mimo"
    public static let minimaxId = "builtin-minimax"
    public static let stepFunId = "builtin-stepfun"
    public static let siliconFlowId = "builtin-siliconflow"
    public static let openRouterId = "builtin-openrouter"

    public static let providers: [ProviderSetting] = [
        OpenAiCompatibleProviderSetting(
            id: openAIId,
            name: "OpenAI",
            baseUrl: "https://api.openai.com/v1",
            sourceType: ProviderSourceTypes.openAI,
            isBuiltIn: true,
            sortOrder: 0,
            systemPrompt: defaultSystemPrompt,
            endpointMode: OpenAiEndpointMode.responses
        ),
        AnthropicProviderSetting(
            id: anthropicId,
            name: "Anthropic",
            baseUrl: "https://api.anthropic.com",
            sourceType: ProviderSourceTypes.anthropic,
            isBuiltIn: true,
            sortOrder: 1,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: bailianId,
            name: "Alibaba DashScope (Bailian)",
            baseUrl: "https://dashscope.aliyuncs.com/compatible-mode/v1",
            sourceType: ProviderSourceTypes.bailian,
            isBuiltIn: true,
            sortOrder: 2,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: deepSeekId,
            name: "DeepSeek",
            baseUrl: "https://api.deepseek.com",
            sourceType: ProviderSourceTypes.deepSeek,
            isBuiltIn: true,
            sortOrder: 3,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: kimiId,
            name: "Kimi (Moonshot)",
            baseUrl: "https://api.moonshot.cn/v1",
            sourceType: ProviderSourceTypes.moonshot,
            isBuiltIn: true,
            sortOrder: 4,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: mimoId,
            name: "MiMo (Xiaomi)",
            baseUrl: "https://api.xiaomimimo.com/v1",
            sourceType: ProviderSourceTypes.mimo,
            isBuiltIn: true,
            sortOrder: 5,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: minimaxId,
            name: "MiniMax",
            baseUrl: "https://api.minimaxi.com/v1",
            sourceType: ProviderSourceTypes.minimax,
            isBuiltIn: true,
            sortOrder: 6,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: stepFunId,
            name: "StepFun",
            baseUrl: "https://api.stepfun.com/v1",
            sourceType: ProviderSourceTypes.stepFun,
            isBuiltIn: true,
            sortOrder: 7,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: siliconFlowId,
            name: "SiliconFlow",
            baseUrl: "https://api.siliconflow.cn/v1",
            sourceType: ProviderSourceTypes.siliconFlow,
            isBuiltIn: true,
            sortOrder: 8,
            systemPrompt: defaultSystemPrompt
        ),
        OpenAiCompatibleProviderSetting(
            id: openRouterId,
            name: "OpenRouter",
            baseUrl: "https://openrouter.ai/api/v1",
            sourceType: ProviderSourceTypes.openRouter,
            isBuiltIn: true,
            sortOrder: 9,
            systemPrompt: defaultSystemPrompt
        )
    ]

    public static func providerById(_ id: String) -> ProviderSetting? {
        providers.first(where: { $0.id == id })
    }
}
