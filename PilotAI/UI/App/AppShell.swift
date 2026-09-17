import SwiftUI

public struct AppShell: View {
    @ObservedObject public var conversationRepo: ConversationRepository
    @ObservedObject public var providerRepo: ProviderRepository
    @ObservedObject public var skillRepo: SkillRepository
    @ObservedObject public var mcpRepo: McpServerRepository
    @ObservedObject public var characterRepo: CharacterRepository
    @ObservedObject public var memoryRepo: AgentMemoryRepository

    public init(
        conversationRepo: ConversationRepository,
        providerRepo: ProviderRepository,
        skillRepo: SkillRepository,
        mcpRepo: McpServerRepository,
        characterRepo: CharacterRepository,
        memoryRepo: AgentMemoryRepository
    ) {
        self.conversationRepo = conversationRepo
        self.providerRepo = providerRepo
        self.skillRepo = skillRepo
        self.mcpRepo = mcpRepo
        self.characterRepo = characterRepo
        self.memoryRepo = memoryRepo
    }

    public var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Conversations")) {
                    Button(action: {
                        _ = conversationRepo.createConversation()
                    }) {
                        Label("New Chat", systemImage: "plus.bubble")
                            .fontWeight(.semibold)
                    }

                    ForEach(conversationRepo.conversations) { conv in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(conv.title)
                                    .font(.body)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            conversationRepo.selectConversation(id: conv.id)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let conv = conversationRepo.conversations[index]
                            conversationRepo.deleteConversation(id: conv.id)
                        }
                    }
                }

                Section(header: Text("App")) {
                    NavigationLink(destination: SettingsView(
                        providerRepo: providerRepo,
                        skillRepo: skillRepo,
                        mcpRepo: mcpRepo,
                        characterRepo: characterRepo,
                        memoryRepo: memoryRepo
                    )) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .navigationTitle("Pilot.AI")
        } detail: {
            NavigationStack {
                ChatHomeView(conversationRepo: conversationRepo, providerRepo: providerRepo)
            }
        }
    }
}
