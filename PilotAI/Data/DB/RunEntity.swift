import Foundation
import SwiftData

@Model
public final class RuntimeResultEntity {
    @Attribute(.unique) public var runId: String
    public var handoffId: String
    public var handoffSource: String
    public var handoffPayload: String
    public var dismissEntrySurface: Bool
    public var ok: Bool
    public var content: String
    public var error: String?
    public var reasoningContent: String
    public var transcriptJson: String
    public var contextSnapshotJson: String
    public var operation: String
    public var rewriteTargetMessageId: String?
    public var createdAt: Int64

    public init(
        runId: String,
        handoffId: String,
        handoffSource: String,
        handoffPayload: String,
        dismissEntrySurface: Bool,
        ok: Bool,
        content: String,
        error: String? = nil,
        reasoningContent: String = "",
        transcriptJson: String = "[]",
        contextSnapshotJson: String = "",
        operation: String = "chat",
        rewriteTargetMessageId: String? = nil,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.runId = runId
        self.handoffId = handoffId
        self.handoffSource = handoffSource
        self.handoffPayload = handoffPayload
        self.dismissEntrySurface = dismissEntrySurface
        self.ok = ok
        self.content = content
        self.error = error
        self.reasoningContent = reasoningContent
        self.transcriptJson = transcriptJson
        self.contextSnapshotJson = contextSnapshotJson
        self.operation = operation
        self.rewriteTargetMessageId = rewriteTargetMessageId
        self.createdAt = createdAt
    }
}

@Model
public final class RuntimeArchiveRunEntity {
    @Attribute(.unique) public var archiveRunId: String
    public var runId: String
    public var handoffId: String
    public var handoffSource: String
    public var handoffPayload: String
    public var dismissEntrySurface: Bool
    public var ok: Bool
    public var content: String
    public var error: String?
    public var reasoningContent: String
    public var transcriptJson: String
    public var contextSnapshotJson: String
    public var operation: String
    public var rewriteTargetMessageId: String?
    public var userImagePreviewsJson: String
    public var createdAt: Int64

    public init(
        archiveRunId: String = UUID().uuidString,
        runId: String,
        handoffId: String,
        handoffSource: String,
        handoffPayload: String,
        dismissEntrySurface: Bool,
        ok: Bool,
        content: String,
        error: String? = nil,
        reasoningContent: String = "",
        transcriptJson: String = "[]",
        contextSnapshotJson: String = "",
        operation: String = "chat",
        rewriteTargetMessageId: String? = nil,
        userImagePreviewsJson: String = "[]",
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.archiveRunId = archiveRunId
        self.runId = runId
        self.handoffId = handoffId
        self.handoffSource = handoffSource
        self.handoffPayload = handoffPayload
        self.dismissEntrySurface = dismissEntrySurface
        self.ok = ok
        self.content = content
        self.error = error
        self.reasoningContent = reasoningContent
        self.transcriptJson = transcriptJson
        self.contextSnapshotJson = contextSnapshotJson
        self.operation = operation
        self.rewriteTargetMessageId = rewriteTargetMessageId
        self.userImagePreviewsJson = userImagePreviewsJson
        self.createdAt = createdAt
    }
}
