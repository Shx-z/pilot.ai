import SwiftUI

public struct CharacterLibraryView: View {
    @ObservedObject public var characterRepo: CharacterRepository

    public init(characterRepo: CharacterRepository) {
        self.characterRepo = characterRepo
    }

    public var body: some View {
        List {
            Section(header: Text("User Persona")) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(characterRepo.userPersonaName)
                        .font(.headline)
                    if !characterRepo.userPersonaDescription.isEmpty {
                        Text(characterRepo.userPersonaDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Section(header: Text("Characters")) {
                if characterRepo.characters.isEmpty {
                    Text("No characters created yet.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(characterRepo.characters) { char in
                        Text(char.name)
                            .font(.body)
                    }
                }
            }
        }
        .navigationTitle("Characters & Persona")
    }
}
