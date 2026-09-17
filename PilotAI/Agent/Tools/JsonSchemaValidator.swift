import Foundation

public enum SchemaValidationError: Error, CustomStringConvertible {
    case missingRequiredProperty(String)
    case typeMismatch(expected: String, actual: String)
    case enumMismatch(val: String, allowed: [String])
    case numberOutOfRange(val: Double, min: Double?, max: Double?)
    case stringLengthMismatch(val: String, minLen: Int?, maxLen: Int?)
    case invalidJson(String)

    public var description: String {
        switch self {
        case .missingRequiredProperty(let prop):
            return "Missing required property: '\(prop)'"
        case .typeMismatch(let exp, let act):
            return "Type mismatch: expected \(exp), got \(act)"
        case .enumMismatch(let val, let allowed):
            return "Value '\(val)' is not in allowed enum list: \(allowed)"
        case .numberOutOfRange(let val, let min, let max):
            return "Number \(val) is out of range [\(min?.description ?? "-inf"), \(max?.description ?? "+inf")]"
        case .stringLengthMismatch(let val, let minLen, let maxLen):
            return "String length \(val.count) is invalid [\(minLen?.description ?? "0")..\(maxLen?.description ?? "inf")]"
        case .invalidJson(let msg):
            return "Invalid JSON: \(msg)"
        }
    }
}

public struct JsonSchemaValidator {
    public static func validate(argumentsJson: String, schemaJson: String) throws {
        guard !schemaJson.isEmpty, schemaJson != "{}" else { return }

        guard let schemaData = schemaJson.data(using: .utf8),
              let schemaDict = try? JSONSerialization.jsonObject(with: schemaData) as? [String: Any] else {
            throw SchemaValidationError.invalidJson("Failed to parse schema JSON")
        }

        guard let argsData = argumentsJson.data(using: .utf8),
              let argsDict = try? JSONSerialization.jsonObject(with: argsData) as? [String: Any] else {
            throw SchemaValidationError.invalidJson("Failed to parse arguments JSON")
        }

        try validateObject(object: argsDict, schema: schemaDict)
    }

    private static func validateObject(object: [String: Any], schema: [String: Any]) throws {
        // Required properties check
        if let requiredProps = schema["required"] as? [String] {
            for prop in requiredProps {
                if object[prop] == nil {
                    throw SchemaValidationError.missingRequiredProperty(prop)
                }
            }
        }

        // Properties check
        if let properties = schema["properties"] as? [String: [String: Any]] {
            for (key, val) in object {
                if let propSchema = properties[key] {
                    try validateValue(value: val, schema: propSchema, propertyName: key)
                }
            }
        }
    }

    private static func validateValue(value: Any, schema: [String: Any], propertyName: String) throws {
        let expectedType = schema["type"] as? String

        if let expectedType = expectedType {
            switch expectedType {
            case "string":
                guard let strVal = value as? String else {
                    throw SchemaValidationError.typeMismatch(expected: "string", actual: "\(type(of: value))")
                }
                if let enumValues = schema["enum"] as? [String], !enumValues.contains(strVal) {
                    throw SchemaValidationError.enumMismatch(val: strVal, allowed: enumValues)
                }
                let minLen = schema["minLength"] as? Int
                let maxLen = schema["maxLength"] as? Int
                if (minLen != nil && strVal.count < minLen!) || (maxLen != nil && strVal.count > maxLen!) {
                    throw SchemaValidationError.stringLengthMismatch(val: strVal, minLen: minLen, maxLen: maxLen)
                }
            case "integer", "number":
                let doubleVal: Double?
                if let num = value as? NSNumber {
                    doubleVal = num.doubleValue
                } else if let dbl = value as? Double {
                    doubleVal = dbl
                } else if let intVal = value as? Int {
                    doubleVal = Double(intVal)
                } else {
                    doubleVal = nil
                }
                guard let numVal = doubleVal else {
                    throw SchemaValidationError.typeMismatch(expected: expectedType, actual: "\(type(of: value))")
                }
                let minVal = (schema["minimum"] as? NSNumber)?.doubleValue
                let maxVal = (schema["maximum"] as? NSNumber)?.doubleValue
                if (minVal != nil && numVal < minVal!) || (maxVal != nil && numVal > maxVal!) {
                    throw SchemaValidationError.numberOutOfRange(val: numVal, min: minVal, max: maxVal)
                }
            case "boolean":
                guard value is Bool else {
                    throw SchemaValidationError.typeMismatch(expected: "boolean", actual: "\(type(of: value))")
                }
            case "object":
                guard let objDict = value as? [String: Any] else {
                    throw SchemaValidationError.typeMismatch(expected: "object", actual: "\(type(of: value))")
                }
                try validateObject(object: objDict, schema: schema)
            case "array":
                guard let array = value as? [Any] else {
                    throw SchemaValidationError.typeMismatch(expected: "array", actual: "\(type(of: value))")
                }
                if let itemSchema = schema["items"] as? [String: Any] {
                    for item in array {
                        try validateValue(value: item, schema: itemSchema, propertyName: propertyName)
                    }
                }
            default:
                break
            }
        }
    }
}
