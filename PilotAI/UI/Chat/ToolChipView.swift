import SwiftUI

public struct ToolChipView: View {
    public let toolName: String
    public let status: String?
    public let argumentsSummary: String?

    public init(toolName: String, status: String? = nil, argumentsSummary: String? = nil) {
        self.toolName = toolName
        self.status = status
        self.argumentsSummary = argumentsSummary
    }

    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "wrench.and.screwdriver.fill")
                .font(.caption)
                .foregroundColor(.blue)
            Text(toolName)
                .font(.caption)
                .fontWeight(.semibold)
            if let args = argumentsSummary, !args.isEmpty {
                Text("(\(args))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            if let st = status {
                Text(st)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(8)
    }
}
