import SwiftUI

public struct AppearanceSettingsView: View {
    @State private var themeMode: AppearanceThemeMode = .system
    @State private var accentColor: AppearanceAccentColor = .system

    public init() {}

    public var body: some View {
        Form {
            Section(header: Text("Theme Mode")) {
                Picker("Theme Mode", selection: $themeMode) {
                    ForEach(AppearanceThemeMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Accent Color")) {
                Picker("Accent Color", selection: $accentColor) {
                    ForEach(AppearanceAccentColor.allCases, id: \.self) { color in
                        Text(color.rawValue.capitalized).tag(color)
                    }
                }
            }
        }
        .navigationTitle("Appearance")
    }
}
