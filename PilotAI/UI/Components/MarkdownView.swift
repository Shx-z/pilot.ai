import SwiftUI

public struct MarkdownView: View {
    public let content: String

    public init(content: String) {
        self.content = content
    }

    public var body: some View {
        if let attributedString = try? AttributedString(markdown: content) {
            Text(attributedString)
                .font(.body)
                .textSelection(.enabled)
        } else {
            Text(content)
                .font(.body)
                .textSelection(.enabled)
        }
    }
}
