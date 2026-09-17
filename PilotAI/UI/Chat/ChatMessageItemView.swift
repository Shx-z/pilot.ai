import SwiftUI

public struct ChatMessageItemView: View {
    public let message: ConversationMessage

    public init(message: ConversationMessage) {
        self.message = message
    }

    public var body: some View {
        HStack {
            if message.type == "user" { Spacer(minLength: 40) }

            VStack(alignment: message.type == "user" ? .trailing : .leading, spacing: 6) {
                if let toolName = message.toolName {
                    ToolChipView(toolName: toolName, status: message.toolStatus, argumentsSummary: message.argumentsSummary)
                } else {
                    MarkdownView(content: message.content)
                        .padding(12)
                        .background(message.type == "user" ? Color.blue : Color(UIColor.secondarySystemBackground))
                        .foregroundColor(message.type == "user" ? .white : .primary)
                        .cornerRadius(16)
                }
            }

            if message.type != "user" { Spacer(minLength: 40) }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
