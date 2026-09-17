import Foundation
import UIKit

public struct AgentTool: Identifiable, Sendable {
    public var id: String { name }
    public let name: String
    public let description: String
    public let isAvailableOnIOS: Bool
    public let schemaJson: String

    public init(name: String, description: String, isAvailableOnIOS: Bool = true, schemaJson: String) {
        self.name = name
        self.description = description
        self.isAvailableOnIOS = isAvailableOnIOS
        self.schemaJson = schemaJson
    }
}

public final class AgentToolCatalog: @unchecked Sendable {
    public static let shared = AgentToolCatalog()

    public let tools: [AgentTool] = [
        AgentTool(
            name: "read_file",
            description: "Read text contents of a file at specified path",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\"}},\"required\":[\"path\"]}"
        ),
        AgentTool(
            name: "write_file",
            description: "Write content to a file at specified path",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\"},\"content\":{\"type\":\"string\"}},\"required\":[\"path\",\"content\"]}"
        ),
        AgentTool(
            name: "list_directory",
            description: "List directory contents",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"path\":{\"type\":\"string\"}},\"required\":[\"path\"]}"
        ),
        AgentTool(
            name: "shell",
            description: "Execute a sandboxed shell command inside iOS container",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"command\":{\"type\":\"string\"}},\"required\":[\"command\"]}"
        ),
        AgentTool(
            name: "read_clipboard",
            description: "Read current clipboard text content",
            schemaJson: "{\"type\":\"object\",\"properties\":{}}"
        ),
        AgentTool(
            name: "write_clipboard",
            description: "Set text content to clipboard",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"text\":{\"type\":\"string\"}},\"required\":[\"text\"]}"
        ),
        AgentTool(
            name: "open_url",
            description: "Open a URL in Safari or system default handler",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"url\":{\"type\":\"string\"}},\"required\":[\"url\"]}"
        ),
        AgentTool(
            name: "memory_read",
            description: "Read MEMORY.md content",
            schemaJson: "{\"type\":\"object\",\"properties\":{}}"
        ),
        AgentTool(
            name: "memory_write",
            description: "Write or update MEMORY.md content",
            schemaJson: "{\"type\":\"object\",\"properties\":{\"content\":{\"type\":\"string\"}},\"required\":[\"content\"]}"
        ),
        AgentTool(
            name: "gui_accessibility_agent",
            description: "Android-only accessibility agent (unavailable on iOS)",
            isAvailableOnIOS: false,
            schemaJson: "{\"type\":\"object\",\"properties\":{}}"
        ),
        AgentTool(
            name: "root_linux_container",
            description: "Android/PRoot root Linux container (unavailable on iOS)",
            isAvailableOnIOS: false,
            schemaJson: "{\"type\":\"object\",\"properties\":{}}"
        )
    ]

    public func availableToolsForIOS() -> [AgentTool] {
        tools.filter { $0.isAvailableOnIOS }
    }
}
