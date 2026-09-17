import Foundation

/// Type-safe dynamic JSON value representation for custom body properties.
public enum AnyJSON: Codable, Hashable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: AnyJSON])
    case array([AnyJSON])
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let boolVal = try? container.decode(Bool.self) {
            self = .bool(boolVal)
        } else if let doubleVal = try? container.decode(Double.self) {
            self = .number(doubleVal)
        } else if let stringVal = try? container.decode(String.self) {
            self = .string(stringVal)
        } else if let arrayVal = try? container.decode([AnyJSON].self) {
            self = .array(arrayVal)
        } else if let objectVal = try? container.decode([String: AnyJSON].self) {
            self = .object(objectVal)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let val): try container.encode(val)
        case .number(let val): try container.encode(val)
        case .bool(let val): try container.encode(val)
        case .object(let val): try container.encode(val)
        case .array(let val): try container.encode(val)
        case .null: try container.encodeNil()
        }
    }
}

/// Dynamic body property payload for model / provider overrides.
public struct CustomBody: Codable, Hashable, Sendable {
    public let key: String
    public let value: AnyJSON

    public init(key: String, value: AnyJSON) {
        self.key = key
        self.value = value
    }
}
