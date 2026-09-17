import Foundation

public final class OpenAiChatCompletionsClient: AgentProviderClient, Sendable {
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
        let endpoint = provider.baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/chat/completions"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if !provider.apiKey.isEmpty {
            request.addValue("Bearer \(provider.apiKey)", forHTTPHeaderField: "Authorization")
        }

        for header in provider.customHeaders {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }

        var bodyDict: [String: Any] = [
            "model": model.modelId,
            "stream": true
        ]

        var payloadMessages: [[String: Any]] = []
        if let sys = systemPrompt ?? provider.systemPrompt, !sys.isEmpty {
            payloadMessages.append(["role": "system", "content": sys])
        }
        for msg in messages {
            var item: [String: Any] = ["role": msg.role, "content": msg.content]
            if let tId = msg.toolCallId { item["tool_call_id"] = tId }
            if let name = msg.name { item["name"] = name }
            payloadMessages.append(item)
        }
        bodyDict["messages"] = payloadMessages

        if !tools.isEmpty {
            let toolsPayload = tools.map { tool -> [String: Any] in
                let schema = (try? JSONSerialization.jsonObject(with: Data(tool.inputSchemaJson.utf8))) ?? [:]
                return [
                    "type": "function",
                    "function": [
                        "name": tool.name,
                        "description": tool.description,
                        "parameters": schema
                    ]
                ]
            }
            bodyDict["tools"] = toolsPayload
        }

        if let effort = effort, effort.enablesReasoning {
            bodyDict["reasoning_effort"] = effort.wireValue
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            eventHandler(.failed(URLError(.init(rawValue: status))))
            return
        }

        var accumulatedToolCalls: [String: (name: String, args: String)] = [:]

        for try await line in bytes.lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.hasPrefix("data:") else { continue }
            let dataStr = trimmed.dropFirst(5).trimmingCharacters(in: .whitespaces)
            if dataStr == "[DONE]" { break }

            guard let jsonData = dataStr.data(using: .utf8),
                  let root = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let choices = root["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let delta = firstChoice["delta"] as? [String: Any] else {
                continue
            }

            // Reasoning delta
            if let reasoning = delta["reasoning_content"] as? String {
                eventHandler(.reasoningDelta(reasoning))
            }

            // Text content delta
            if let content = delta["content"] as? String {
                eventHandler(.textDelta(content))
            }

            // Tool calls delta
            if let toolCalls = delta["tool_calls"] as? [[String: Any]] {
                for toolCall in toolCalls {
                    let index = toolCall["index"] as? Int ?? 0
                    let id = toolCall["id"] as? String ?? "call_\(index)"
                    if let function = toolCall["function"] as? [String: Any] {
                        let name = function["name"] as? String ?? ""
                        let args = function["arguments"] as? String ?? ""
                        var current = accumulatedToolCalls[id] ?? (name: "", args: "")
                        if !name.isEmpty { current.name = name }
                        current.args += args
                        accumulatedToolCalls[id] = current
                        eventHandler(.toolCallDelta(id: id, name: current.name, argsDelta: args))
                    }
                }
            }
        }

        let finalToolCalls = accumulatedToolCalls.map { (id, val) in
            ProviderToolCall(id: id, name: val.name, argumentsJson: val.args)
        }
        eventHandler(.completed(toolCalls: finalToolCalls, usage: nil))
    }
}
