import Foundation

public enum ModelSource: String, Codable, Sendable {
    case manual = "MANUAL"
    case remote = "REMOTE"
    case catalog = "CATALOG"
}

public struct Model: Codable, Identifiable, Hashable, Sendable {
    public let id: String
    public let modelId: String
    public let displayName: String
    public let ownedBy: String?
    public let isEnabled: Bool
    public let isBuiltIn: Bool
    public let sortOrder: Int
    public let contextWindow: Int?
    public let contextWindowOverride: Int?
    public let inputModalities: [String]
    public let outputModalities: [String]
    public let attachment: Bool?
    public let toolCall: Bool?
    public let reasoning: Bool?
    public let reasoningCapabilities: ModelReasoningCapabilities?
    public let reasoningOverride: Bool?
    public let reasoningCapabilitiesOverride: ModelReasoningCapabilities?
    public let structuredOutput: Bool?
    public let supportsTemperature: Bool?
    public let customHeaders: [CustomHeader]
    public let customBody: [CustomBody]
    public let source: ModelSource
    public let createdAt: Int64

    public static let textModality = "text"
    public static let imageModality = "image"

    public init(
        id: String,
        modelId: String,
        displayName: String,
        ownedBy: String? = nil,
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        sortOrder: Int = 0,
        contextWindow: Int? = nil,
        contextWindowOverride: Int? = nil,
        inputModalities: [String] = [Model.textModality],
        outputModalities: [String] = [Model.textModality],
        attachment: Bool? = nil,
        toolCall: Bool? = nil,
        reasoning: Bool? = nil,
        reasoningCapabilities: ModelReasoningCapabilities? = nil,
        reasoningOverride: Bool? = nil,
        reasoningCapabilitiesOverride: ModelReasoningCapabilities? = nil,
        structuredOutput: Bool? = nil,
        supportsTemperature: Bool? = nil,
        customHeaders: [CustomHeader] = [],
        customBody: [CustomBody] = [],
        source: ModelSource = .manual,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.modelId = modelId
        self.displayName = displayName
        self.ownedBy = ownedBy
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.sortOrder = sortOrder
        self.contextWindow = contextWindow
        self.contextWindowOverride = contextWindowOverride
        self.inputModalities = inputModalities
        self.outputModalities = outputModalities
        self.attachment = attachment
        self.toolCall = toolCall
        self.reasoning = reasoning
        self.reasoningCapabilities = reasoningCapabilities
        self.reasoningOverride = reasoningOverride
        self.reasoningCapabilitiesOverride = reasoningCapabilitiesOverride
        self.structuredOutput = structuredOutput
        self.supportsTemperature = supportsTemperature
        self.customHeaders = customHeaders
        self.customBody = customBody
        self.source = source
        self.createdAt = createdAt
    }

    public var effectiveContextWindow: Int? {
        contextWindowOverride ?? contextWindow
    }

    public var effectiveReasoning: Bool? {
        reasoningOverride ?? reasoning
    }

    public var effectiveReasoningCapabilities: ModelReasoningCapabilities? {
        switch reasoningOverride {
        case false: return nil
        case true: return reasoningCapabilitiesOverride ?? ModelReasoningCapabilities()
        case nil: return reasoningCapabilities
        }
    }

    public var supportsVision: Bool {
        attachment == true || inputModalities.contains(where: { $0.caseInsensitiveCompare(Self.imageModality) == .orderedSame })
    }

    public var supportsTools: Bool {
        toolCall == true
    }

    public var supportsReasoning: Bool {
        effectiveReasoning == true
    }
}
