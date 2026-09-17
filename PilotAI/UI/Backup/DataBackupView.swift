import SwiftUI

public struct DataBackupView: View {
    @ObservedObject public var providerRepo: ProviderRepository
    @ObservedObject public var skillRepo: SkillRepository
    @ObservedObject public var mcpRepo: McpServerRepository
    @ObservedObject public var characterRepo: CharacterRepository
    @State private var exportStatusMessage: String? = nil

    public init(
        providerRepo: ProviderRepository,
        skillRepo: SkillRepository,
        mcpRepo: McpServerRepository,
        characterRepo: CharacterRepository
    ) {
        self.providerRepo = providerRepo
        self.skillRepo = skillRepo
        self.mcpRepo = mcpRepo
        self.characterRepo = characterRepo
    }

    public var body: some View {
        List {
            Section(header: Text("Export Data")) {
                Button(action: exportData) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Backup JSON")
                    }
                }
            }

            if let msg = exportStatusMessage {
                Section {
                    Text(msg)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .navigationTitle("Data Backup")
    }

    private func exportData() {
        do {
            let data = try EtaBackupRepository.exportBackup(
                settings: nil,
                providers: providerRepo.providers,
                skills: skillRepo.skills,
                mcpServers: mcpRepo.servers,
                characters: characterRepo.characters,
                personaName: characterRepo.userPersonaName,
                personaDesc: characterRepo.userPersonaDescription
            )
            exportStatusMessage = "Successfully exported \(data.count) bytes."
        } catch {
            exportStatusMessage = "Export failed: \(error.localizedDescription)"
        }
    }
}
