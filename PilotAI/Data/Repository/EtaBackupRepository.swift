import Foundation

public struct EtaBackupPayload: Codable, Sendable {
    public let version: Int
    public let createdAt: Int64
    public let settings: Settings?
    public let providers: [AnyProviderSetting]
    public let skills: [Skill]
    public let mcpServers: [McpServerSetting]
    public let characters: [CharacterItem]
    public let userPersonaName: String
    public let userPersonaDescription: String

    public init(
        version: Int = 1,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        settings: Settings? = nil,
        providers: [AnyProviderSetting] = [],
        skills: [Skill] = [],
        mcpServers: [McpServerSetting] = [],
        characters: [CharacterItem] = [],
        userPersonaName: String = "User",
        userPersonaDescription: String = ""
    ) {
        self.version = version
        self.createdAt = createdAt
        self.settings = settings
        self.providers = providers
        self.skills = skills
        self.mcpServers = mcpServers
        self.characters = characters
        self.userPersonaName = userPersonaName
        self.userPersonaDescription = userPersonaDescription
    }
}

@MainActor
public final class EtaBackupRepository {
    public static func exportBackup(
        settings: Settings?,
        providers: [ProviderSetting],
        skills: [Skill],
        mcpServers: [McpServerSetting],
        characters: [CharacterItem],
        personaName: String,
        personaDesc: String
    ) throws -> Data {
        let wrappedProviders = providers.compactMap { p -> AnyProviderSetting? in
            if let o = p as? OpenAiCompatibleProviderSetting { return .openAI(o) }
            if let a = p as? AnthropicProviderSetting { return .anthropic(a) }
            if let c = p as? CustomProviderSetting { return .custom(c) }
            return nil
        }
        let payload = EtaBackupPayload(
            settings: settings,
            providers: wrappedProviders,
            skills: skills,
            mcpServers: mcpServers,
            characters: characters,
            userPersonaName: personaName,
            userPersonaDescription: personaDesc
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(payload)
    }

    public static func importBackup(from data: Data) throws -> EtaBackupPayload {
        let decoder = JSONDecoder()
        return try decoder.decode(EtaBackupPayload.self, from: data)
    }
}
