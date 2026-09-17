import Foundation

public final class SkillManager: Sendable {
    public init() {}

    public func fetchSkillFromGitHub(repoURLString: String) async throws -> Skill {
        guard let url = URL(string: repoURLString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let content = String(data: data, encoding: .utf8) ?? ""
        let name = url.lastPathComponent.replacingOccurrences(of: ".git", with: "")

        return Skill(
            name: name,
            descriptionText: "Installed from \(repoURLString)",
            location: "remote",
            sourceUrl: repoURLString,
            isEnabled: true,
            isBuiltIn: false,
            promptContent: content
        )
    }
}
