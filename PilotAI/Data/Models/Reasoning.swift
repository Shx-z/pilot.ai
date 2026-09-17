import Foundation

public enum ReasoningEffort: String, Codable, CaseIterable, Sendable {
    case off = "off"
    case defaultEffort = "default"
    case minimal = "minimal"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case xhigh = "xhigh"
    case max = "max"

    public var wireValue: String { rawValue }

    public var displayName: String {
        switch self {
        case .off: return "Off"
        case .defaultEffort: return "Default"
        case .minimal: return "Minimal"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .xhigh: return "XHigh"
        case .max: return "Max"
        }
    }

    public var rank: Int {
        switch self {
        case .off: return 0
        case .defaultEffort: return 1
        case .minimal: return 2
        case .low: return 3
        case .medium: return 4
        case .high: return 5
        case .xhigh: return 6
        case .max: return 7
        }
    }

    public var enablesReasoning: Boolean {
        self != .off
    }

    public typealias Boolean = Bool

    public static func fromWireValue(_ value: String?) -> ReasoningEffort? {
        guard let normalized = value?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !normalized.isEmpty else {
            return nil
        }
        if let exact = ReasoningEffort(rawValue: normalized) { return exact }
        switch normalized {
        case "none": return .off
        case "x-high", "extra_high", "extra-high": return .xhigh
        default: return nil
        }
    }

    public static func fromLegacy(thinkingEnabled: Bool) -> ReasoningEffort {
        thinkingEnabled ? .defaultEffort : .off
    }
}

public struct ModelReasoningCapabilities: Codable, Hashable, Sendable {
    public let supportedEfforts: [ReasoningEffort]
    public let defaultEffort: ReasoningEffort?
    public let defaultEnabled: Bool?
    public let mandatory: Bool
    public let canDisable: Bool
    public let supportsBudget: Bool
    public let maxBudgetTokens: Int?
    public let supportsMaxTokens: Bool?

    public init(
        supportedEfforts: [ReasoningEffort] = [],
        defaultEffort: ReasoningEffort? = nil,
        defaultEnabled: Bool? = nil,
        mandatory: Bool = false,
        canDisable: Bool = false,
        supportsBudget: Bool = false,
        maxBudgetTokens: Int? = nil,
        supportsMaxTokens: Bool? = nil
    ) {
        self.supportedEfforts = supportedEfforts
        self.defaultEffort = defaultEffort
        self.defaultEnabled = defaultEnabled
        self.mandatory = mandatory
        self.canDisable = canDisable
        self.supportsBudget = supportsBudget
        self.maxBudgetTokens = maxBudgetTokens
        self.supportsMaxTokens = supportsMaxTokens
    }

    public var selectableEfforts: [ReasoningEffort] {
        var result: [ReasoningEffort] = []
        if canDisable && !mandatory {
            result.append(.off)
        }
        result.append(.defaultEffort)
        let filtered = supportedEfforts
            .filter { $0 != .off && $0 != .defaultEffort }
            .sorted(by: { $0.rank < $1.rank })
        for effort in filtered {
            if !result.contains(effort) {
                result.append(effort)
            }
        }
        return result
    }

    public func normalize(requested: ReasoningEffort) -> ReasoningEffort {
        let selectable = selectableEfforts
        if selectable.contains(requested) { return requested }
        if requested == .off || requested == .defaultEffort { return .defaultEffort }
        return selectable
            .filter { $0 != .off && $0.rank <= requested.rank }
            .max(by: { $0.rank < $1.rank }) ?? .defaultEffort
    }
}
