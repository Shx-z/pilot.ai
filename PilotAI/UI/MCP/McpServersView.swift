import SwiftUI

public struct McpServersView: View {
    @ObservedObject public var mcpRepo: McpServerRepository

    public init(mcpRepo: McpServerRepository) {
        self.mcpRepo = mcpRepo
    }

    public var body: some View {
        List {
            if mcpRepo.servers.isEmpty {
                ListEmptyState(
                    iconName: "network",
                    title: "No MCP Servers",
                    message: "Model Context Protocol servers enable remote tool integration."
                )
            } else {
                Section(header: Text("MCP Servers")) {
                    ForEach(mcpRepo.servers) { server in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(server.name).font(.headline)
                            Text(server.url).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("MCP Servers")
    }
}
