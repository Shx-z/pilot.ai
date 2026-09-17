import Foundation
import SwiftData

public struct ConversationMessage: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let conversationId: String
    public let sortIndex: Int
    public let type: String
    public let content: String
    public let imagesJson: String
    public let isEdited: Bool
    public let renderMarkdown: Bool?
    public let contextTokens: Int?
    public let inputTokens: Int?
    public let outputTokens: Int?
    public let reasoningTokens: Int?
    public let cachedTokens: Int?
    public let elapsedSeconds: Int?
    public let toolName: String?
    public let toolStatus: String?
    public let argumentsSummary: String?
    public let resultSummary: String?
    public let imageCount: Int
    public let toolsJson: String

    public init(
        id: String = UUID().uuidString,
        conversationId: String,
        sortIndex: Int,
        type: String,
        content: String,
        imagesJson: String = "[]",
        isEdited: Bool = false,
        renderMarkdown: Bool? = nil,
        contextTokens: Int? = nil,
        inputTokens: Int? = nil,
        outputTokens: Int? = nil,
        reasoningTokens: Int? = nil,
        cachedTokens: Int? = nil,
        elapsedSeconds: Int? = nil,
        toolName: String? = nil,
        toolStatus: String? = nil,
        argumentsSummary: String? = nil,
        resultSummary: String? = nil,
        imageCount: Int = 0,
        toolsJson: String = "[]"
    ) {
        self.id = id
        self.conversationId = conversationId
        self.sortIndex = sortIndex
        self.type = type
        self.content = content
        self.imagesJson = imagesJson
        self.isEdited = isEdited
        self.renderMarkdown = renderMarkdown
        self.contextTokens = contextTokens
        self.inputTokens = inputTokens
        self.outputTokens = outputTokens
        self.reasoningTokens = reasoningTokens
        self.cachedTokens = cachedTokens
        self.elapsedSeconds = elapsedSeconds
        self.toolName = toolName
        self.toolStatus = toolStatus
        self.argumentsSummary = argumentsSummary
        self.resultSummary = resultSummary
        self.imageCount = imageCount
        self.toolsJson = toolsJson
    }
}

public struct Conversation: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public var title: String
    public var thinkingEnabled: Bool
    public var reasoningEffort: String
    public var historyJson: String
    public var createdAt: Int64
    public var updatedAt: Int64

    public init(
        id: String = UUID().uuidString,
        title: String = "New Chat",
        thinkingEnabled: Bool = false,
        reasoningEffort: String = "default",
        historyJson: String = "[]",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.title = title
        self.thinkingEnabled = thinkingEnabled
        self.reasoningEffort = reasoningEffort
        self.historyJson = historyJson
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@MainActor
public final class ConversationRepository: ObservableObject {
    @Published public private(set) var conversations: [Conversation] = []
    @Published public private(set) var activeConversationId: String? = nil

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.loadConversations()
    }

    public func loadConversations() {
        let descriptor = FetchDescriptor<ConversationEntity>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
        if let entities = try? modelContext.fetch(descriptor) {
            self.conversations = entities.map {
                Conversation(
                    id: $0.id,
                    title: $0.title,
                    thinkingEnabled: $0.thinkingEnabled,
                    reasoningEffort: $0.reasoningEffort,
                    historyJson: $0.historyJson,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
            if activeConversationId == nil {
                activeConversationId = conversations.first?.id
            }
        }
    }

    public func createConversation(title: String = "New Chat") -> Conversation {
        let conversation = Conversation(title: title)
        let entity = ConversationEntity(
            id: conversation.id,
            title: conversation.title,
            thinkingEnabled: conversation.thinkingEnabled,
            reasoningEffort: conversation.reasoningEffort,
            historyJson: conversation.historyJson,
            createdAt: conversation.createdAt,
            updatedAt: conversation.updatedAt
        )
        modelContext.insert(entity)
        try? modelContext.save()
        self.loadConversations()
        self.activeConversationId = conversation.id
        return conversation
    }

    public func selectConversation(id: String) {
        self.activeConversationId = id
    }

    public func deleteConversation(id: String) {
        let descriptor = FetchDescriptor<ConversationEntity>(predicate: #Predicate { $0.id == id })
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            try? modelContext.save()
            self.loadConversations()
            if activeConversationId == id {
                activeConversationId = conversations.first?.id
            }
        }
    }

    public func loadMessages(for conversationId: String) -> [ConversationMessage] {
        let descriptor = FetchDescriptor<MessageEntity>(
            predicate: #Predicate { $0.conversationId == conversationId },
            sortBy: [SortDescriptor(\.sortIndex)]
        )
        guard let entities = try? modelContext.fetch(descriptor) else { return [] }
        return entities.map {
            ConversationMessage(
                id: $0.id,
                conversationId: $0.conversationId,
                sortIndex: $0.sortIndex,
                type: $0.type,
                content: $0.content,
                imagesJson: $0.imagesJson,
                isEdited: $0.isEdited,
                renderMarkdown: $0.renderMarkdown,
                contextTokens: $0.contextTokens,
                inputTokens: $0.inputTokens,
                outputTokens: $0.outputTokens,
                reasoningTokens: $0.reasoningTokens,
                cachedTokens: $0.cachedTokens,
                elapsedSeconds: $0.elapsedSeconds,
                toolName: $0.toolName,
                toolStatus: $0.toolStatus,
                argumentsSummary: $0.argumentsSummary,
                resultSummary: $0.resultSummary,
                imageCount: $0.imageCount,
                toolsJson: $0.toolsJson
            )
        }
    }

    public func addMessage(_ message: ConversationMessage) {
        let entity = MessageEntity(
            id: message.id,
            conversationId: message.conversationId,
            sortIndex: message.sortIndex,
            type: message.type,
            content: message.content,
            imagesJson: message.imagesJson,
            isEdited: message.isEdited,
            renderMarkdown: message.renderMarkdown,
            contextTokens: message.contextTokens,
            inputTokens: message.inputTokens,
            outputTokens: message.outputTokens,
            reasoningTokens: message.reasoningTokens,
            cachedTokens: message.cachedTokens,
            elapsedSeconds: message.elapsedSeconds,
            toolName: message.toolName,
            toolStatus: message.toolStatus,
            argumentsSummary: message.argumentsSummary,
            resultSummary: message.resultSummary,
            imageCount: message.imageCount,
            toolsJson: message.toolsJson
        )
        modelContext.insert(entity)

        // Update conversation timestamp
        let cid = message.conversationId
        let descriptor = FetchDescriptor<ConversationEntity>(predicate: #Predicate { $0.id == cid })
        if let conv = try? modelContext.fetch(descriptor).first {
            conv.updatedAt = Int64(Date().timeIntervalSince1970 * 1000)
        }

        try? modelContext.save()
        self.loadConversations()
    }
}
