import Foundation

@MainActor
public final class AgentMemoryRepository: ObservableObject {
    @Published public var isMemoryEnabled: Bool = true
    @Published public private(set) var memoryContent: String = ""

    private let memoryFileURL: URL

    public init() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.memoryFileURL = docs.appendingPathComponent("MEMORY.md")
        self.loadMemory()
    }

    public func loadMemory() {
        if FileManager.default.fileExists(atPath: memoryFileURL.path) {
            do {
                self.memoryContent = try String(contentsOf: memoryFileURL, encoding: .utf8)
            } catch {
                print("Failed to read MEMORY.md: \(error)")
                self.memoryContent = ""
            }
        } else {
            let initial = """
            # Eta Agent Memory File

            Use this file to store persistent notes, user preferences, and long-term project context.
            """
            self.memoryContent = initial
            try? initial.write(to: memoryFileURL, atomically: true, encoding: .utf8)
        }
    }

    public func updateMemory(_ newContent: String) {
        self.memoryContent = newContent
        try? newContent.write(to: memoryFileURL, atomically: true, encoding: .utf8)
    }

    public func clearMemory() {
        self.updateMemory("# Eta Agent Memory File\n")
    }
}
