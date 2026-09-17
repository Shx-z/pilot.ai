import Foundation
import SwiftData

@MainActor
public final class ProviderRepository: ObservableObject {
    @Published public private(set) var providers: [ProviderSetting] = []
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.loadProviders()
    }

    public func loadProviders() {
        let descriptor = FetchDescriptor<ProviderEntity>(sortBy: [SortDescriptor(\.sortOrder)])
        do {
            let entities = try modelContext.fetch(descriptor)
            if entities.isEmpty {
                self.seedBuiltinProviders()
            } else {
                self.providers = entities.compactMap { self.toProviderSetting(from: $0) }
            }
        } catch {
            print("Failed to fetch providers: \(error)")
            self.providers = BuiltinProviders.providers
        }
    }

    public func seedBuiltinProviders() {
        for setting in BuiltinProviders.providers {
            let entity = toProviderEntity(from: setting)
            modelContext.insert(entity)
        }
        try? modelContext.save()
        self.loadProviders()
    }

    public func saveProvider(_ provider: ProviderSetting) {
        let targetId = provider.id
        let descriptor = FetchDescriptor<ProviderEntity>(predicate: #Predicate { $0.id == targetId })
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.name = provider.name
            existing.baseUrl = provider.baseUrl
            existing.apiKey = provider.apiKey
            existing.isEnabled = provider.isEnabled
            existing.sortOrder = provider.sortOrder
            existing.systemPrompt = provider.systemPrompt
            existing.hostedWebSearchEnabled = provider.hostedWebSearchEnabled
            if let customHeaders = try? JSONEncoder().encode(provider.customHeaders) {
                existing.customHeadersJson = String(data: customHeaders, encoding: .utf8) ?? "[]"
            }
            if let customBody = try? JSONEncoder().encode(provider.customBody) {
                existing.customBodyJson = String(data: customBody, encoding: .utf8) ?? "[]"
            }
        } else {
            let entity = toProviderEntity(from: provider)
            modelContext.insert(entity)
        }
        try? modelContext.save()
        self.loadProviders()
    }

    public func deleteProvider(id: String) {
        let descriptor = FetchDescriptor<ProviderEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
            self.loadProviders()
        }
    }

    private func toProviderEntity(from setting: ProviderSetting) -> ProviderEntity {
        let headersJson = (try? String(data: JSONEncoder().encode(setting.customHeaders), encoding: .utf8)) ?? "[]"
        let bodyJson = (try? String(data: JSONEncoder().encode(setting.customBody), encoding: .utf8)) ?? "[]"

        var endpointMode = OpenAiEndpointMode.chatCompletions
        var anthropicVersion = AnthropicProviderSetting.defaultAnthropicVersion

        if let openAi = setting as? OpenAiCompatibleProviderSetting {
            endpointMode = openAi.endpointMode
        } else if let anthropic = setting as? AnthropicProviderSetting {
            anthropicVersion = anthropic.anthropicVersion
        }

        return ProviderEntity(
            id: setting.id,
            name: setting.name,
            baseUrl: setting.baseUrl,
            type: setting.runtimeProviderType,
            sourceType: setting.sourceType,
            apiKey: setting.apiKey,
            isEnabled: setting.isEnabled,
            isBuiltIn: setting.isBuiltIn,
            sortOrder: setting.sortOrder,
            systemPrompt: setting.systemPrompt,
            endpointMode: endpointMode,
            anthropicVersion: anthropicVersion,
            hostedWebSearchEnabled: setting.hostedWebSearchEnabled,
            customHeadersJson: headersJson,
            customBodyJson: bodyJson,
            createdAt: setting.createdAt
        )
    }

    private func toProviderSetting(from entity: ProviderEntity) -> ProviderSetting? {
        let headers = (try? JSONDecoder().decode([CustomHeader].self, from: Data(entity.customHeadersJson.utf8))) ?? []
        let body = (try? JSONDecoder().decode([CustomBody].self, from: Data(entity.customBodyJson.utf8))) ?? []
        let catalogModels = OfficialModelCatalog.modelsForSource(entity.sourceType)

        switch entity.type {
        case ProviderTypes.anthropic:
            return AnthropicProviderSetting(
                id: entity.id,
                name: entity.name,
                baseUrl: entity.baseUrl,
                sourceType: entity.sourceType,
                apiKey: entity.apiKey,
                isEnabled: entity.isEnabled,
                isBuiltIn: entity.isBuiltIn,
                sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt,
                models: catalogModels,
                customHeaders: headers,
                customBody: body,
                createdAt: entity.createdAt,
                anthropicVersion: entity.anthropicVersion
            )
        case ProviderTypes.custom:
            return CustomProviderSetting(
                id: entity.id,
                name: entity.name,
                baseUrl: entity.baseUrl,
                sourceType: entity.sourceType,
                apiKey: entity.apiKey,
                isEnabled: entity.isEnabled,
                isBuiltIn: entity.isBuiltIn,
                sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt,
                models: catalogModels,
                customHeaders: headers,
                customBody: body,
                createdAt: entity.createdAt,
                endpointMode: entity.endpointMode,
                hostedWebSearchEnabled: entity.hostedWebSearchEnabled
            )
        default:
            return OpenAiCompatibleProviderSetting(
                id: entity.id,
                name: entity.name,
                baseUrl: entity.baseUrl,
                sourceType: entity.sourceType,
                apiKey: entity.apiKey,
                isEnabled: entity.isEnabled,
                isBuiltIn: entity.isBuiltIn,
                sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt,
                models: catalogModels,
                customHeaders: headers,
                customBody: body,
                createdAt: entity.createdAt,
                endpointMode: entity.endpointMode,
                hostedWebSearchEnabled: entity.hostedWebSearchEnabled
            )
        }
    }
}
