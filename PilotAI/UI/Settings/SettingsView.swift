import SwiftUI

public struct SettingsView: View {
    @ObservedObject public var providerRepo: ProviderRepository
    @ObservedObject public var skillRepo: SkillRepository
    @ObservedObject public var mcpRepo: McpServerRepository
    @ObservedObject public var characterRepo: CharacterRepository
    @ObservedObject public var memoryRepo: AgentMemoryRepository

    public init(
        providerRepo: ProviderRepository,
        skillRepo: SkillRepository,
        mcpRepo: McpServerRepository,
        characterRepo: CharacterRepository,
        memoryRepo: AgentMemoryRepository
    ) {
        self.providerRepo = providerRepo
        self.skillRepo = skillRepo
        self.mcpRepo = mcpRepo
        self.characterRepo = characterRepo
        self.memoryRepo = memoryRepo
    }

    public var body: some View {
        List {
            Section(header: Text("Core Configuration")) {
                NavigationLink(destination: ProviderListView(providerRepo: providerRepo)) {
                    Label("Model Providers", systemImage: "cpu")
                }
                NavigationLink(destination: AgentToolsView()) {
                    Label("Agent Tools", systemImage: "wrench.and.screwdriver")
                }
                NavigationLink(destination: AgentSkillsView(skillRepo: skillRepo)) {
                    Label("Skills", systemImage: "bolt.horizontal")
                }
                NavigationLink(destination: AgentMemoryView(memoryRepo: memoryRepo)) {
                    Label("Memory (MEMORY.md)", systemImage: "brain")
                }
                NavigationLink(destination: CharacterLibraryView(characterRepo: characterRepo)) {
                    Label("Characters & Personas", systemImage: "person.crop.square")
                }
                NavigationLink(destination: McpServersView(mcpRepo: mcpRepo)) {
                    Label("MCP Servers", systemImage: "network")
                }
            }

            Section(header: Text("Tools & Utilities")) {
                NavigationLink(destination: AgentBrowserView()) {
                    Label("Built-in Browser", systemImage: "safari")
                }
                NavigationLink(destination: DataBackupView(
                    providerRepo: providerRepo,
                    skillRepo: skillRepo,
                    mcpRepo: mcpRepo,
                    characterRepo: characterRepo
                )) {
                    Label("Data Backup", systemImage: "square.and.arrow.up")
                }
                NavigationLink(destination: AppearanceSettingsView()) {
                    Label("Appearance", systemImage: "paintpalette")
                }
            }

            Section(header: Text("System")) {
                PermissionHealthCard()
            }
        }
        .navigationTitle("Settings")
    }
}
