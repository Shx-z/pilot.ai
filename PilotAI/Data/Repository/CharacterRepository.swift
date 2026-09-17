import Foundation
import SwiftData

public struct CharacterItem: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var name: String
    public var cardJson: String
    public var avatarPath: String?
    public var archived: Bool
    public let createdAt: Int64
    public var updatedAt: Int64

    public init(
        id: String = UUID().uuidString,
        name: String,
        cardJson: String = "{}",
        avatarPath: String? = nil,
        archived: Bool = false,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.cardJson = cardJson
        self.avatarPath = avatarPath
        self.archived = archived
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@MainActor
public final class CharacterRepository: ObservableObject {
    @Published public private(set) var characters: [CharacterItem] = []
    @Published public private(set) var userPersonaName: String = "User"
    @Published public private(set) var userPersonaDescription: String = ""

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.loadCharacters()
        self.loadPersona()
    }

    public func loadCharacters() {
        let descriptor = FetchDescriptor<CharacterEntity>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
        if let entities = try? modelContext.fetch(descriptor) {
            self.characters = entities.map {
                CharacterItem(
                    id: $0.id,
                    name: $0.name,
                    cardJson: $0.cardJson,
                    avatarPath: $0.avatarPath,
                    archived: $0.archived,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
        }
    }

    public func loadPersona() {
        let descriptor = FetchDescriptor<UserPersonaEntity>()
        if let entity = try? modelContext.fetch(descriptor).first {
            self.userPersonaName = entity.name
            self.userPersonaDescription = entity.descriptionText
        } else {
            let entity = UserPersonaEntity(id: "main", name: "User", descriptionText: "")
            modelContext.insert(entity)
            try? modelContext.save()
        }
    }

    public func savePersona(name: String, description: String) {
        self.userPersonaName = name
        self.userPersonaDescription = description
        let descriptor = FetchDescriptor<UserPersonaEntity>()
        if let entity = try? modelContext.fetch(descriptor).first {
            entity.name = name
            entity.descriptionText = description
            try? modelContext.save()
        }
    }

    public func saveCharacter(_ character: CharacterItem) {
        let targetId = character.id
        let descriptor = FetchDescriptor<CharacterEntity>(predicate: #Predicate { $0.id == targetId })
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.name = character.name
            existing.cardJson = character.cardJson
            existing.avatarPath = character.avatarPath
            existing.archived = character.archived
            existing.updatedAt = Int64(Date().timeIntervalSince1970 * 1000)
        } else {
            let entity = CharacterEntity(
                id: character.id,
                name: character.name,
                cardJson: character.cardJson,
                avatarPath: character.avatarPath,
                archived: character.archived,
                createdAt: character.createdAt,
                updatedAt: character.updatedAt
            )
            modelContext.insert(entity)
        }
        try? modelContext.save()
        self.loadCharacters()
    }

    public func deleteCharacter(id: String) {
        let descriptor = FetchDescriptor<CharacterEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
            self.loadCharacters()
        }
    }
}
