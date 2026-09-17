import SwiftUI

public struct AgentMemoryView: View {
    @ObservedObject public var memoryRepo: AgentMemoryRepository
    @State private var text: String = ""

    public init(memoryRepo: AgentMemoryRepository) {
        self.memoryRepo = memoryRepo
        _text = State(initialValue: memoryRepo.memoryContent)
    }

    public var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $text)
                .font(.monospaced(.body)())
                .padding(8)

            HStack {
                Button("Clear Memory") {
                    memoryRepo.clearMemory()
                    text = memoryRepo.memoryContent
                }
                .foregroundColor(.red)

                Spacer()

                Button("Save MEMORY.md") {
                    memoryRepo.updateMemory(text)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
        }
        .navigationTitle("Agent Memory")
        .onAppear {
            text = memoryRepo.memoryContent
        }
    }
}
