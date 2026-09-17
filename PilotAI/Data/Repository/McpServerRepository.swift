import Foundation
import SwiftData

@MainActor
public final class McpServerRepository: ObservableObject {
    @Published public private(set) var servers: [McpServerSetting] = []
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.loadServers()
    }

    public func loadServers() {
        let descriptor = FetchDescriptor<McpServerEntity>(sortBy: [SortDescriptor(\.sortOrder)])
        if let entities = try? modelContext.fetch(descriptor) {
            self.servers = entities.map { entity in
                let tools = (try? JSONDecoder().decode([McpToolDefinition].self, from: Data(entity.toolsJson.utf8))) ?? []
                let enabledNames = (try? JSONDecoder().decode(Set<String>.self, from: Data(entity.enabledToolNamesJson.utf8))) ?? []
                return McpServerSetting(
                    id: entity.id,
                    name: entity.name,
                    url: entity.url,
                    enabled: entity.enabled,
                    protocolMode: entity.protocolMode,
                    authorizationType: entity.authorizationType,
                    tools: tools,
                    enabledToolNames: enabledNames,
                    createdAt: entity.createdAt,
                    sortOrder: entity.sortOrder,
                    lastRefreshedAt: entity.lastRefreshedAt,
                    lastProtocolVersion: entity.lastProtocolVersion,
                    toolsExpireAt: entity.toolsExpireAt
                )
            }
        }
    }

    public func saveServer(_ server: McpServerSetting) {
        let targetId = server.id
        let toolsJson = (try? String(data: JSONEncoder().encode(server.tools), encoding: .utf8)) ?? "[]"
        let namesJson = (try? String(data: JSONEncoder().encode(server.enabledToolNames), encoding: .utf8)) ?? "[]"

        let descriptor = FetchDescriptor<McpServerEntity>(predicate: #Predicate { $0.id == targetId })
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.name = server.name
            existing.url = server.url
            existing.enabled = server.enabled
            existing.protocolMode = server.protocolMode
            existing.authorizationType = server.authorizationType
            existing.toolsJson = toolsJson
            existing.enabledToolNamesJson = namesJson
            existing.lastRefreshedAt = server.lastRefreshedAt
            existing.lastProtocolVersion = server.lastProtocolVersion
            existing.toolsExpireAt = server.toolsExpireAt
        } else {
            let entity = McpServerEntity(
                id: server.id,
                name: server.name,
                url: server.url,
                enabled: server.enabled,
                protocolMode: server.protocolMode,
                authorizationType: server.authorizationType,
                toolsJson: toolsJson,
                enabledToolNamesJson: namesJson,
                createdAt: server.createdAt,
                sortOrder: server.sortOrder,
                lastRefreshedAt: server.lastRefreshedAt,
                lastProtocolVersion: server.lastProtocolVersion,
                toolsExpireAt: server.toolsExpireAt
            )
            modelContext.insert(entity)
        }
        try? modelContext.save()
        self.loadServers()
    }

    public func deleteServer(id: String) {
        let descriptor = FetchDescriptor<McpServerEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
            self.loadServers()
        }
    }
}
