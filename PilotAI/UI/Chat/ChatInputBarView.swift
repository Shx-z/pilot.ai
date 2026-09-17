import SwiftUI

public struct ChatInputBarView: View {
    @Binding public var text: String
    public let isRunning: Bool
    public let onSend: () -> Void
    public let onStop: () -> Void

    public init(text: Binding<String>, isRunning: Bool, onSend: @escaping () -> Void, onStop: @escaping () -> Void) {
        self._text = text
        self.isRunning = isRunning
        self.onSend = onSend
        self.onStop = onStop
    }

    public var body: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }

            TextField("Ask Pilot.AI anything...", text: $text, axis: .vertical)
                .lineLimit(1...5)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)

            if isRunning {
                Button(action: onStop) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            } else {
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
}
