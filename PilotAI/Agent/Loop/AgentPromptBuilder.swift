import Foundation

public struct AgentPromptBuilder {
    public static func buildSystemPrompt(
        providerPrompt: String?,
        userPersonaName: String = "User",
        userPersonaDescription: String = "",
        memoryContent: String = "",
        skills: [Skill] = []
    ) -> String {
        var parts: [String] = []

        let baseIdentity = providerPrompt ?? BuiltinProviders.defaultSystemPrompt
        parts.append(baseIdentity)

        parts.append("""
        
        # System Identity & Environment
        - Client Platform: iOS
        - Assistant Name: Pilot.AI
        - System Guidelines: Execute tool calls sequentially when needed. Respect user preferences.
        """)

        if !userPersonaDescription.isEmpty {
            parts.append("""
            
            # User Persona
            - Name: \(userPersonaName)
            - Profile: \(userPersonaDescription)
            """)
        }

        if !memoryContent.isEmpty {
            parts.append("""
            
            # Long-Term Memory (MEMORY.md)
            \(memoryContent)
            """)
        }

        let activeSkills = skills.filter { $0.isEnabled }
        if !activeSkills.isEmpty {
            var skillText = "\n# Available Skills\n"
            for skill in activeSkills {
                skillText += "## Skill: \(skill.name)\n\(skill.promptContent)\n\n"
            }
            parts.append(skillText)
        }

        return parts.joined(separator: "\n")
    }
}
