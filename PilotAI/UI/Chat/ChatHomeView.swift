import SwiftUI

public struct ChatHomeView: View {
    @ObservedObject public var conversationRepo: ConversationRepository
    @ObservedObject public var providerRepo: ProviderRepository
    @State private var inputText: String = ""
    @State private var isRunning: Bool = false
    @State private var statusText: String = "Pilot.AI is thinking..."

    public init(conversationRepo: ConversationRepository, providerRepo: ProviderRepository) {
        self.conversationRepo = conversationRepo
        self.providerRepo = providerRepo
    }

    public var body: some View {
        VStack(spacing: 0) {
            if let activeId = conversationRepo.activeConversationId {
                let messages = conversationRepo.loadMessages(for: activeId)
                if messages.isEmpty {
                    ListEmptyState(
                        iconName: "sparkles",
                        title: "How can Pilot.AI help today?",
                        message: "Send a message to start reasoning, using tools, or exploring ideas."
                    )
                    Spacer()
                } else {
                    MessageListView(messages: messages)
                }
            } else {
                ListEmptyState(
                    iconName: "bubble.left.and.bubble.right",
                    title: "No Conversation Selected",
                    message: "Create or select a conversation from the sidebar."
                )
                Spacer()
            }

            AgentStatusCardView(
                isRunning: isRunning,
                statusText: statusText,
                onStop: { isRunning = false }
            )

            ChatInputBarView(
                text: $inputText,
                isRunning: isRunning,
                onSend: sendMessage,
                onStop: { isRunning = false }
            )
        }
        .navigationTitle("Pilot.AI")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let conversationId: String
        if let currentId = conversationRepo.activeConversationId {
            conversationId = currentId
        } else {
            let newConv = conversationRepo.createConversation(title: String(inputText.prefix(20)))
            conversationId = newConv.id
        }

        let userMsg = ConversationMessage(
            conversationId: conversationId,
            sortIndex: conversationRepo.loadMessages(for: conversationId).count,
            type: "user",
            content: inputText
        )
        conversationRepo.addMessage(userMsg)

        let prompt = inputText
        inputText = ""
        isRunning = true
        statusText = "Reasoning..."

        // Launch async agent loop stream simulation
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let assistantMsg = ConversationMessage(
                conversationId: conversationId,
                sortIndex: conversationRepo.loadMessages(for: conversationId).count,
                type: "assistant",
                content: "Received your query: \"\(prompt)\". I'm ready to execute tasks and tools for you."
            )
            await MainActor.run {
                conversationRepo.addMessage(assistantMsg)
                isRunning = false
            }
        }
    }
}
