import Foundation

public struct ProviderTypes {
    public static let openAICompatible = "openai_compatible"
    public static let anthropic = "anthropic"
    public static let custom = "custom"
}

public struct OpenAiEndpointMode {
    public static let chatCompletions = "chat_completions"
    public static let responses = "responses"
}

public struct ProviderSourceTypes {
    public static let custom = "custom"
    public static let openAI = "openai"
    public static let anthropic = "anthropic"
    public static let bailian = "bailian"
    public static let deepSeek = "deepseek"
    public static let moonshot = "moonshot"
    public static let mimo = "mimo"
    public static let minimax = "minimax"
    public static let stepFun = "stepfun"
    public static let siliconFlow = "siliconflow"
    public static let openRouter = "openrouter"
}

public protocol ProviderSetting: Codable, Sendable {
    var id: String { get }
    var name: String { get }
    var baseUrl: String { get }
    var sourceType: String { get }
    var apiKey: String { get }
    var isEnabled: Bool { get }
    var isBuiltIn: Bool { get }
    var sortOrder: Int { get }
    var systemPrompt: String? { get }
    var models: [Model] { get }
    var customHeaders: [CustomHeader] { get }
    var customBody: [CustomBody] { get }
    var createdAt: Int64 { get }
    var hostedWebSearchEnabled: Bool { get }

    var runtimeProviderType: String { get }
    var typeLabel: String { get }
    var displayApiKeySummary: String { get }

    func selectedOrFirstModel(modelId: String?) -> Model?
    func copyWith(
        id: String?,
        name: String?,
        baseUrl: String?,
        sourceType: String?,
        apiKey: String?,
        isEnabled: Bool?,
        isBuiltIn: Bool?,
        sortOrder: Int?,
        systemPrompt: String?,
        models: [Model]?,
        customHeaders: [CustomHeader]?,
        customBody: [CustomBody]?,
        hostedWebSearchEnabled: Bool?
    ) -> ProviderSetting
}

public extension ProviderSetting {
    var displayApiKeySummary: String {
        if apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Not Configured"
        }
        if apiKey.count <= 8 {
            return String(repeating: "*", count: apiKey.count)
        }
        let prefix = apiKey.prefix(4)
        let suffix = apiKey.suffix(4)
        let stars = String(repeating: "*", count: apiKey.count - 8)
        return "\(prefix)\(stars)\(suffix)"
    }

    func selectedOrFirstModel(modelId: String?) -> Model? {
        if let modelId = modelId, let match = models.first(where: { $0.id == modelId && $0.isEnabled }) {
            return match
        }
        return models.filter { $0.isEnabled }.min(by: { $0.sortOrder < $1.sortOrder })
    }
}

public struct OpenAiCompatibleProviderSetting: ProviderSetting, Hashable {
    public let id: String
    public let name: String
    public let baseUrl: String
    public let sourceType: String
    public let apiKey: String
    public let isEnabled: Bool
    public let isBuiltIn: Bool
    public let sortOrder: Int
    public let systemPrompt: String?
    public let models: [Model]
    public let customHeaders: [CustomHeader]
    public let customBody: [CustomBody]
    public let createdAt: Int64
    public let endpointMode: String
    public let hostedWebSearchEnabled: Bool

    public init(
        id: String,
        name: String,
        baseUrl: String,
        sourceType: String = ProviderSourceTypes.custom,
        apiKey: String = "",
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        sortOrder: Int = 0,
        systemPrompt: String? = nil,
        models: [Model] = [],
        customHeaders: [CustomHeader] = [],
        customBody: [CustomBody] = [],
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        endpointMode: String = OpenAiEndpointMode.chatCompletions,
        hostedWebSearchEnabled: Bool = false
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl
        self.sourceType = sourceType
        self.apiKey = apiKey
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.sortOrder = sortOrder
        self.systemPrompt = systemPrompt
        self.models = models
        self.customHeaders = customHeaders
        self.customBody = customBody
        self.createdAt = createdAt
        self.endpointMode = endpointMode
        self.hostedWebSearchEnabled = hostedWebSearchEnabled
    }

    public var runtimeProviderType: String { ProviderTypes.openAICompatible }
    public var typeLabel: String { "OpenAI-compatible" }

    public func copyWith(
        id: String? = nil,
        name: String? = nil,
        baseUrl: String? = nil,
        sourceType: String? = nil,
        apiKey: String? = nil,
        isEnabled: Bool? = nil,
        isBuiltIn: Bool? = nil,
        sortOrder: Int? = nil,
        systemPrompt: String? = nil,
        models: [Model]? = nil,
        customHeaders: [CustomHeader]? = nil,
        customBody: [CustomBody]? = nil,
        hostedWebSearchEnabled: Bool? = nil
    ) -> ProviderSetting {
        OpenAiCompatibleProviderSetting(
            id: id ?? self.id,
            name: name ?? self.name,
            baseUrl: baseUrl ?? self.baseUrl,
            sourceType: sourceType ?? self.sourceType,
            apiKey: apiKey ?? self.apiKey,
            isEnabled: isEnabled ?? self.isEnabled,
            isBuiltIn: isBuiltIn ?? self.isBuiltIn,
            sortOrder: sortOrder ?? self.sortOrder,
            systemPrompt: systemPrompt ?? self.systemPrompt,
            models: models ?? self.models,
            customHeaders: customHeaders ?? self.customHeaders,
            customBody: customBody ?? self.customBody,
            createdAt: self.createdAt,
            endpointMode: self.endpointMode,
            hostedWebSearchEnabled: hostedWebSearchEnabled ?? self.hostedWebSearchEnabled
        )
    }
}

public struct AnthropicProviderSetting: ProviderSetting, Hashable {
    public let id: String
    public let name: String
    public let baseUrl: String
    public let sourceType: String
    public let apiKey: String
    public let isEnabled: Bool
    public let isBuiltIn: Bool
    public let sortOrder: Int
    public let systemPrompt: String?
    public let models: [Model]
    public let customHeaders: [CustomHeader]
    public let customBody: [CustomBody]
    public let createdAt: Int64
    public let anthropicVersion: String
    public var hostedWebSearchEnabled: Bool { false }

    public static let defaultAnthropicVersion = "2023-06-01"

    public init(
        id: String,
        name: String,
        baseUrl: String,
        sourceType: String = ProviderSourceTypes.custom,
        apiKey: String = "",
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        sortOrder: Int = 0,
        systemPrompt: String? = nil,
        models: [Model] = [],
        customHeaders: [CustomHeader] = [],
        customBody: [CustomBody] = [],
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        anthropicVersion: String = AnthropicProviderSetting.defaultAnthropicVersion
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl
        self.sourceType = sourceType
        self.apiKey = apiKey
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.sortOrder = sortOrder
        self.systemPrompt = systemPrompt
        self.models = models
        self.customHeaders = customHeaders
        self.customBody = customBody
        self.createdAt = createdAt
        self.anthropicVersion = anthropicVersion
    }

    public var runtimeProviderType: String { ProviderTypes.anthropic }
    public var typeLabel: String { "Anthropic Messages" }

    public func copyWith(
        id: String? = nil,
        name: String? = nil,
        baseUrl: String? = nil,
        sourceType: String? = nil,
        apiKey: String? = nil,
        isEnabled: Bool? = nil,
        isBuiltIn: Bool? = nil,
        sortOrder: Int? = nil,
        systemPrompt: String? = nil,
        models: [Model]? = nil,
        customHeaders: [CustomHeader]? = nil,
        customBody: [CustomBody]? = nil,
        hostedWebSearchEnabled: Bool? = nil
    ) -> ProviderSetting {
        AnthropicProviderSetting(
            id: id ?? self.id,
            name: name ?? self.name,
            baseUrl: baseUrl ?? self.baseUrl,
            sourceType: sourceType ?? self.sourceType,
            apiKey: apiKey ?? self.apiKey,
            isEnabled: isEnabled ?? self.isEnabled,
            isBuiltIn: isBuiltIn ?? self.isBuiltIn,
            sortOrder: sortOrder ?? self.sortOrder,
            systemPrompt: systemPrompt ?? self.systemPrompt,
            models: models ?? self.models,
            customHeaders: customHeaders ?? self.customHeaders,
            customBody: customBody ?? self.customBody,
            createdAt: self.createdAt,
            anthropicVersion: self.anthropicVersion
        )
    }
}

public struct CustomProviderSetting: ProviderSetting, Hashable {
    public let id: String
    public let name: String
    public let baseUrl: String
    public let sourceType: String
    public let apiKey: String
    public let isEnabled: Bool
    public let isBuiltIn: Bool
    public let sortOrder: Int
    public let systemPrompt: String?
    public let models: [Model]
    public let customHeaders: [CustomHeader]
    public let customBody: [CustomBody]
    public let createdAt: Int64
    public let endpointMode: String
    public let hostedWebSearchEnabled: Bool

    public init(
        id: String,
        name: String,
        baseUrl: String,
        sourceType: String = ProviderSourceTypes.custom,
        apiKey: String = "",
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        sortOrder: Int = 0,
        systemPrompt: String? = nil,
        models: [Model] = [],
        customHeaders: [CustomHeader] = [],
        customBody: [CustomBody] = [],
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        endpointMode: String = OpenAiEndpointMode.chatCompletions,
        hostedWebSearchEnabled: Bool = false
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl
        self.sourceType = sourceType
        self.apiKey = apiKey
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.sortOrder = sortOrder
        self.systemPrompt = systemPrompt
        self.models = models
        self.customHeaders = customHeaders
        self.customBody = customBody
        self.createdAt = createdAt
        self.endpointMode = endpointMode
        self.hostedWebSearchEnabled = hostedWebSearchEnabled
    }

    public var runtimeProviderType: String { ProviderTypes.openAICompatible }
    public var typeLabel: String { "Custom OpenAI-compatible" }

    public func copyWith(
        id: String? = nil,
        name: String? = nil,
        baseUrl: String? = nil,
        sourceType: String? = nil,
        apiKey: String? = nil,
        isEnabled: Bool? = nil,
        isBuiltIn: Bool? = nil,
        sortOrder: Int? = nil,
        systemPrompt: String? = nil,
        models: [Model]? = nil,
        customHeaders: [CustomHeader]? = nil,
        customBody: [CustomBody]? = nil,
        hostedWebSearchEnabled: Bool? = nil
    ) -> ProviderSetting {
        CustomProviderSetting(
            id: id ?? self.id,
            name: name ?? self.name,
            baseUrl: baseUrl ?? self.baseUrl,
            sourceType: sourceType ?? self.sourceType,
            apiKey: apiKey ?? self.apiKey,
            isEnabled: isEnabled ?? self.isEnabled,
            isBuiltIn: isBuiltIn ?? self.isBuiltIn,
            sortOrder: sortOrder ?? self.sortOrder,
            systemPrompt: systemPrompt ?? self.systemPrompt,
            models: models ?? self.models,
            customHeaders: customHeaders ?? self.customHeaders,
            customBody: customBody ?? self.customBody,
            createdAt: self.createdAt,
            endpointMode: self.endpointMode,
            hostedWebSearchEnabled: hostedWebSearchEnabled ?? self.hostedWebSearchEnabled
        )
    }
}

/// Helper wrapper for polymorphically decoding / encoding ProviderSetting objects in Swift JSON.
public enum AnyProviderSetting: Codable, Sendable {
    case openAI(OpenAiCompatibleProviderSetting)
    case anthropic(AnthropicProviderSetting)
    case custom(CustomProviderSetting)

    public var setting: ProviderSetting {
        switch self {
        case .openAI(let s): return s
        case .anthropic(let s): return s
        case .custom(let s): return s
        }
    }

    enum CodingKeys: String, CodingKey {
        case type = "type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case ProviderTypes.anthropic:
            let s = try AnthropicProviderSetting(from: decoder)
            self = .anthropic(s)
        case ProviderTypes.custom:
            let s = try CustomProviderSetting(from: decoder)
            self = .custom(s)
        default:
            let s = try OpenAiCompatibleProviderSetting(from: decoder)
            self = .openAI(s)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .openAI(let s):
            try container.encode(ProviderTypes.openAICompatible, forKey: .type)
            try s.encode(to: encoder)
        case .anthropic(let s):
            try container.encode(ProviderTypes.anthropic, forKey: .type)
            try s.encode(to: encoder)
        case .custom(let s):
            try container.encode(ProviderTypes.custom, forKey: .type)
            try s.encode(to: encoder)
        }
    }
}
