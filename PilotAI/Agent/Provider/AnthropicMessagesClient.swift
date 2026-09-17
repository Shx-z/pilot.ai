import Foundation

public final class AnthropicMessagesClient: AgentProviderClient, Sendable {
    public init() {}

    public func stream(
        provider: ProviderSetting,
        model: Model,
        messages: [ProviderMessage],
        systemPrompt: String?,
        tools: [ProviderToolDefinition],
        effort: ReasoningEffort?,
        eventHandler: @escaping @Sendable (ProviderStreamEvent) -> Void
    ) async throws {
        let endpoint = provider.baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/v1/messages"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        if !provider.apiKey.isEmpty {
            request.addValue(provider.apiKey, forHTTPHeaderField: "x-api-key")
        }

        for header in provider.customHeaders {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }

        var bodyDict: [String: Any] = [
            "model": model.modelId,
            "max_tokens": 4096,
            "stream": true
        ]

        if let sys = systemPrompt ?? provider.systemPrompt, !sys.isEmpty {
            bodyDict["system"] = sys
        }

        let payloadMessages = messages.map { msg -> [String: Any] in
            ["role": msg.role == "assistant" ? "assistant" : "user", "content": msg.content]
        }
        bodyDict["messages"] = payloadMessages

        if !tools.isEmpty {
            let toolsPayload = tools.map { tool -> [String: Any] in
                let schema = (try? JSONSerialization.jsonObject(with: Data(tool.inputSchemaJson.utf8))) ?? [:]
                return [
                    "name": tool.name,
                    "description": tool.description,
                    "input_schema": schema
                ]
            }
            bodyDict["tools"] = toolsPayload
        }

        if let effort = effort, effort.enablesReasoning {
            bodyDict["thinking"] = ["type": "enabled", "budget_tokens": 2048]
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            eventHandler(.failed(URLError(.init(rawValue: status))))
            return
        }

        var accumulatedToolCalls: [String: (name: String, args: String)] = [:]
        var currentToolId: String = ""

        for try await line in bytes.lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.hasPrefix("data:") else { continue }
            let dataStr = trimmed.dropFirst(5).trimmingCharacters(in: .whitespaces)

            guard let jsonData = dataStr.data(using: .utf8),
                  let root = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let type = root["type"] as? String else {
                continue
            }

            switch type {
            case "content_block_start":
                if let contentBlock = root["content_block"] as? [String: Any],
                   let blockType = contentBlock["type"] as? String,
                   blockType == "tool_use",
                   let id = contentBlock["id"] as? String,
                   let name = contentBlock["name"] as? String {
                    currentToolId = id
                    accumulatedToolCalls[id] = (name: name, args: "")
                }
            case "content_block_delta":
                if let delta = root["delta"] as? [String: Any],
                   let deltaType = delta["type"] as? String {
                    if deltaType == "text_delta", let text = delta["text"] as? String {
                        eventHandler(.textDelta(text))
                    } else if deltaType == "thinking_delta", let thinking = delta["thinking"] as? String {
                        eventHandler(.reasoningDelta(thinking))
                    } else if deltaType == "input_json_delta", let partialJson = delta["partial_json"] as? String {
                        if !currentToolId.isEmpty {
                            var current = accumulatedToolCalls[currentToolId] ?? (name: "", args: "")
                            current.args += partialJson
                            accumulatedToolCalls[currentToolId] = current
                            eventHandler(.toolCallDelta(id: currentToolId, name: current.name, argsDelta: partialJson))
                        }
                    }
                }
            default:
                break
            }
        }

        let finalToolCalls = accumulatedToolCalls.map { (id, val) in
            ProviderToolCall(id: id, name: val.name, argumentsJson: val.args)
        }
        eventHandler(.completed(toolCalls: finalToolCalls, usage: nil))
    }
}
