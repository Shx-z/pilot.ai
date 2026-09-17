import SwiftUI

public struct ProviderListView: View {
    @ObservedObject public var providerRepo: ProviderRepository
    @State private var editingProvider: ProviderSetting? = nil
    
    public init(providerRepo: ProviderRepository) {
        self.providerRepo = providerRepo
    }
    
    public var body: some View {
        List {
            Section(header: Text("Configured Model Providers")) {
                ForEach(providerRepo.providers, id: \.id) { provider in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(provider.name)
                                .font(.headline)
                            Text(provider.typeLabel)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(provider.displayApiKeySummary)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if provider.isEnabled {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingProvider = provider
                    }
                }
            }
        }
        .navigationTitle("Model Providers")
        .sheet(item: Binding(
            get: { editingProvider },
            set: { editingProvider = $0 }
        )) { provider in
            ProviderEditSheet(provider: provider, repo: providerRepo)
        }
    }
}

struct ProviderEditSheet: View {
    let provider: ProviderSetting
    @ObservedObject var repo: ProviderRepository
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = ""
    @State private var baseUrl: String = ""

    init(provider: ProviderSetting, repo: ProviderRepository) {
        self.provider = provider
        self.repo = repo
        _apiKey = State(initialValue: provider.apiKey)
        _baseUrl = State(initialValue: provider.baseUrl)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Provider Settings")) {
                    Text(provider.name).font(.headline)
                    TextField("Base URL", text: $baseUrl)
                    SecureField("API Key", text: $apiKey)
                }
            }
            .navigationTitle("Edit \(provider.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = provider.copyWith(
                            id: nil,
                            name: nil,
                            baseUrl: baseUrl,
                            sourceType: nil,
                            apiKey: apiKey,
                            isEnabled: nil,
                            isBuiltIn: nil,
                            sortOrder: nil,
                            systemPrompt: nil,
                            models: nil,
                            customHeaders: nil,
                            customBody: nil,
                            hostedWebSearchEnabled: nil
                        )
                        repo.saveProvider(updated)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
