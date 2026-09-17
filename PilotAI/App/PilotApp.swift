import SwiftUI
import SwiftData

@main
public struct PilotApp: App {
    public let container: ModelContainer

    @StateObject private var providerRepo: ProviderRepository
    @StateObject private var conversationRepo: ConversationRepository
    @StateObject private var skillRepo: SkillRepository
    @StateObject private var mcpRepo: McpServerRepository
    @StateObject private var characterRepo: CharacterRepository
    @StateObject private var memoryRepo: AgentMemoryRepository

    public init() {
        let schema = Schema([
            ConversationEntity.self,
            MessageEntity.self,
            RuntimeResultEntity.self,
            RuntimeArchiveRunEntity.self,
            ProviderEntity.self,
            SkillEntity.self,
            McpServerEntity.self,
            CharacterEntity.self,
            UserPersonaEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.container = container

            let context = container.mainContext
            _providerRepo = StateObject(wrappedValue: ProviderRepository(modelContext: context))
            _conversationRepo = StateObject(wrappedValue: ConversationRepository(modelContext: context))
            _skillRepo = StateObject(wrappedValue: SkillRepository(modelContext: context))
            _mcpRepo = StateObject(wrappedValue: McpServerRepository(modelContext: context))
            _characterRepo = StateObject(wrappedValue: CharacterRepository(modelContext: context))
            _memoryRepo = StateObject(wrappedValue: AgentMemoryRepository())
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    public var body: some Scene {
        WindowGroup {
            AppShell(
                conversationRepo: conversationRepo,
                providerRepo: providerRepo,
                skillRepo: skillRepo,
                mcpRepo: mcpRepo,
                characterRepo: characterRepo,
                memoryRepo: memoryRepo
            )
        }
        .modelContainer(container)
    }
}
