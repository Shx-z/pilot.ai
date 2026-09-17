import SwiftUI

public struct AgentStatusCardView: View {
    public let isRunning: Bool
    public let statusText: String
    public let onStop: () -> Void

    public init(isRunning: Bool, statusText: String, onStop: @escaping () -> Void) {
        self.isRunning = isRunning
        self.statusText = statusText
        self.onStop = onStop
    }

    public var body: some View {
        if isRunning {
            HStack(spacing: 12) {
                ProgressView()
                Text(statusText)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
                Button(action: onStop) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .cornerRadius(12)
            .padding(.horizontal)
            .shadow(radius: 4)
        }
    }
}
