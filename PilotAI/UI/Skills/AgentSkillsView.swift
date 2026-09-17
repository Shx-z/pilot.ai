import SwiftUI

public struct AgentSkillsView: View {
    @ObservedObject public var skillRepo: SkillRepository

    public init(skillRepo: SkillRepository) {
        self.skillRepo = skillRepo
    }

    public var body: some View {
        List {
            if skillRepo.skills.isEmpty {
                ListEmptyState(
                    iconName: "bolt.horizontal.circle",
                    title: "No Skills Installed",
                    message: "Skills add capabilities and custom prompts to Eta."
                )
            } else {
                Section(header: Text("Installed Skills")) {
                    ForEach(skillRepo.skills) { skill in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(skill.name)
                                    .font(.headline)
                                Text(skill.descriptionText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { skill.isEnabled },
                                set: { _ in skillRepo.toggleSkill(id: skill.id) }
                            ))
                        }
                    }
                }
            }
        }
        .navigationTitle("Agent Skills")
    }
}
