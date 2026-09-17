import Foundation
import SwiftData

public struct Skill: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let descriptionText: String
    public let location: String
    public let sourceUrl: String?
    public var isEnabled: Bool
    public var isBuiltIn: Bool
    public var promptContent: String
    public let createdAt: Int64

    public init(
        id: String = UUID().uuidString,
        name: String,
        descriptionText: String = "",
        location: String,
        sourceUrl: String? = nil,
        isEnabled: Bool = true,
        isBuiltIn: Bool = false,
        promptContent: String = "",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.location = location
        self.sourceUrl = sourceUrl
        self.isEnabled = isEnabled
        self.isBuiltIn = isBuiltIn
        self.promptContent = promptContent
        self.createdAt = createdAt
    }
}

@MainActor
public final class SkillRepository: ObservableObject {
    @Published public private(set) var skills: [Skill] = []
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.loadSkills()
    }

    public func loadSkills() {
        let descriptor = FetchDescriptor<SkillEntity>(sortBy: [SortDescriptor(\.name)])
        if let entities = try? modelContext.fetch(descriptor) {
            self.skills = entities.map {
                Skill(
                    id: $0.id,
                    name: $0.name,
                    descriptionText: $0.descriptionText,
                    location: $0.location,
                    sourceUrl: $0.sourceUrl,
                    isEnabled: $0.isEnabled,
                    isBuiltIn: $0.isBuiltIn,
                    promptContent: $0.promptContent,
                    createdAt: $0.createdAt
                )
            }
        }
    }

    public func addSkill(_ skill: Skill) {
        let entity = SkillEntity(
            id: skill.id,
            name: skill.name,
            descriptionText: skill.descriptionText,
            location: skill.location,
            sourceUrl: skill.sourceUrl,
            isEnabled: skill.isEnabled,
            isBuiltIn: skill.isBuiltIn,
            promptContent: skill.promptContent,
            createdAt: skill.createdAt
        )
        modelContext.insert(entity)
        try? modelContext.save()
        self.loadSkills()
    }

    public func toggleSkill(id: String) {
        let descriptor = FetchDescriptor<SkillEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.isEnabled.toggle()
            try? modelContext.save()
            self.loadSkills()
        }
    }

    public func deleteSkill(id: String) {
        let descriptor = FetchDescriptor<SkillEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
            self.loadSkills()
        }
    }
}
