import Foundation

public struct Settings: Codable, Hashable, Sendable {
    public var selectedProviderId: String?
    public var selectedModelId: String?
    public var memoryEnabled: Bool
    public var appearance: AppearanceSettings

    public init(
        selectedProviderId: String? = nil,
        selectedModelId: String? = nil,
        memoryEnabled: Bool = true,
        appearance: AppearanceSettings = AppearanceSettings()
    ) {
        self.selectedProviderId = selectedProviderId
        self.selectedModelId = selectedModelId
        self.memoryEnabled = memoryEnabled
        self.appearance = appearance
    }
}
