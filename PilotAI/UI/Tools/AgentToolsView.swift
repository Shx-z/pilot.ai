import SwiftUI

public struct AgentToolsView: View {
    let tools = AgentToolCatalog.shared.tools

    public init() {}

    public var body: some View {
        List {
            Section(header: Text("iOS Tool Catalog")) {
                ForEach(tools) { tool in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(tool.name)
                                    .font(.headline)
                                if !tool.isAvailableOnIOS {
                                    Text("Android Only")
                                        .font(.caption2)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.2))
                                        .foregroundColor(.orange)
                                        .cornerRadius(4)
                                }
                            }
                            Text(tool.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: tool.isAvailableOnIOS ? "checkmark.seal.fill" : "xmark.seal.fill")
                            .foregroundColor(tool.isAvailableOnIOS ? .green : .gray)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Agent Tools")
    }
}
