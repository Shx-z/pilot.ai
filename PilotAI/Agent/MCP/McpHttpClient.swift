import Foundation

public final class McpHttpClient: Sendable {
    public init() {}

    public func discoverTools(server: McpServerSetting) async throws -> [McpToolDefinition] {
        guard let url = URL(string: server.url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(server.protocolMode, forHTTPHeaderField: "mcp-protocol-version")

        let payload: [String: Any] = [
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/list",
            "params": [:]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        guard let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let result = root["result"] as? [String: Any],
              let toolsArray = result["tools"] as? [[String: Any]] else {
            return []
        }

        return toolsArray.compactMap { dict in
            guard let name = dict["name"] as? String else { return nil }
            let title = dict["title"] as? String ?? ""
            let desc = dict["description"] as? String ?? ""
            let schema = dict["inputSchema"] as? [String: Any] ?? [:]
            let schemaJson = (try? String(data: JSONSerialization.data(withJSONObject: schema), encoding: .utf8)) ?? "{}"
            return McpToolDefinition(
                name: name,
                title: title,
                description: desc,
                inputSchemaJson: schemaJson
            )
        }
    }

    public func callTool(server: McpServerSetting, toolName: String, arguments: [String: Any]) async throws -> String {
        guard let url = URL(string: server.url) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": [
                "name": toolName,
                "arguments": arguments
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (data, _) = try await URLSession.shared.data(for: request)
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}
