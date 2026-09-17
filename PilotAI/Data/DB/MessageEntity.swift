import Foundation
import SwiftData

@Model
public final class MessageEntity {
    @Attribute(.unique) public var id: String
    public var conversationId: String
    public var sortIndex: Int
    public var type: String
    public var content: String
    public var imagesJson: String
    public var isEdited: Bool
    public var renderMarkdown: Bool?
    public var contextTokens: Int?
    public var inputTokens: Int?
    public var outputTokens: Int?
    public var reasoningTokens: Int?
    public var cachedTokens: Int?
    public var elapsedSeconds: Int?
    public var toolName: String?
    public var toolStatus: String?
    public var argumentsSummary: String?
    public var resultSummary: String?
    public var imageCount: Int
    public var toolsJson: String

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
