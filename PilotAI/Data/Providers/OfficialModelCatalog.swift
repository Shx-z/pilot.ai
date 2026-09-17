import Foundation

public struct OfficialModelCatalog {
    private static func officialModel(
        id: String,
        modelId: String,
        displayName: String,
        ownedBy: String,
        inputModalities: [String] = [Model.textModality],
        outputModalities: [String] = [Model.textModality],
        contextWindow: Int? = nil,
        attachment: Bool? = nil,
        toolCall: Bool? = nil,
        reasoning: Bool? = nil,
        structuredOutput: Bool? = nil,
        supportsTemperature: Bool? = nil
    ) -> Model {
        Model(
            id: id,
            modelId: modelId,
            displayName: displayName,
            ownedBy: ownedBy,
            isBuiltIn: true,
            contextWindow: contextWindow,
            inputModalities: inputModalities,
            outputModalities: outputModalities,
            attachment: attachment,
            toolCall: toolCall,
            reasoning: reasoning,
            structuredOutput: structuredOutput,
            supportsTemperature: supportsTemperature,
            source: .catalog
        )
    }

    private static let modelsByCatalogId: [String: [Model]] = [
        ProviderSourceTypes.openAI: [
            officialModel(id: "builtin-openai-gpt-5-6-sol", modelId: "gpt-5.6-sol", displayName: "GPT-5.6 Sol", ownedBy: "openai", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_050_000, toolCall: true, reasoning: true, structuredOutput: true),
            officialModel(id: "builtin-openai-gpt-5-6-terra", modelId: "gpt-5.6-terra", displayName: "GPT-5.6 Terra", ownedBy: "openai", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_050_000, toolCall: true, reasoning: true, structuredOutput: true),
            officialModel(id: "builtin-openai-gpt-5-6-luna", modelId: "gpt-5.6-luna", displayName: "GPT-5.6 Luna", ownedBy: "openai", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_050_000, toolCall: true, reasoning: true, structuredOutput: true),
            officialModel(id: "builtin-openai-gpt-5-5", modelId: "gpt-5.5", displayName: "GPT-5.5", ownedBy: "openai", inputModalities: [Model.textModality, Model.imageModality], toolCall: true, reasoning: true)
        ],
        ProviderSourceTypes.anthropic: [
            officialModel(id: "builtin-anthropic-claude-fable-5", modelId: "claude-fable-5", displayName: "Claude Fable 5", ownedBy: "anthropic", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_000_000, toolCall: true, reasoning: true),
            officialModel(id: "builtin-anthropic-claude-opus-4-8", modelId: "claude-opus-4-8", displayName: "Claude Opus 4.8", ownedBy: "anthropic", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_000_000, toolCall: true, reasoning: true),
            officialModel(id: "builtin-anthropic-claude-sonnet-5", modelId: "claude-sonnet-5", displayName: "Claude Sonnet 5", ownedBy: "anthropic", inputModalities: [Model.textModality, Model.imageModality], contextWindow: 1_000_000, toolCall: true, reasoning: true)
        ],
        ProviderSourceTypes.deepSeek: [
            officialModel(id: "builtin-deepseek-v4-pro", modelId: "deepseek-v4-pro", displayName: "DeepSeek V4 Pro", ownedBy: "deepseek", contextWindow: 1_000_000, toolCall: true, reasoning: true),
            officialModel(id: "builtin-deepseek-v4-flash", modelId: "deepseek-v4-flash", displayName: "DeepSeek V4 Flash", ownedBy: "deepseek", contextWindow: 1_000_000, toolCall: true, reasoning: true)
        ],
        ProviderSourceTypes.moonshot: [
            officialModel(id: "builtin-kimi-k3", modelId: "kimi-k3", displayName: "Kimi K3", ownedBy: "moonshot", inputModalities: [Model.textModality, Model.imageModality, "video"], contextWindow: 1_048_576, toolCall: true, reasoning: true, structuredOutput: true),
            officialModel(id: "builtin-kimi-k2-7-code", modelId: "kimi-k2.7-code", displayName: "Kimi K2.7 Code", ownedBy: "moonshot", inputModalities: [Model.textModality, Model.imageModality, "video"], contextWindow: 256_000, toolCall: true, reasoning: true, structuredOutput: true)
        ]
    ]

    public static func modelsForSource(_ sourceType: String) -> [Model] {
        modelsByCatalogId[sourceType] ?? []
    }
}
