import Foundation

public struct AppearanceSettingsConsts {
    public static let minInterfaceScale: Float = 0.8
    public static let maxInterfaceScale: Float = 1.1
    public static let defaultInterfaceScale: Float = 1.0
}

public enum AppearanceThemeMode: String, Codable, CaseIterable, Sendable {
    case system = "system"
    case light = "light"
    case dark = "dark"
}

public enum AppearancePaletteStyle: String, Codable, CaseIterable, Sendable {
    case tonalSpot = "tonal_spot"
    case neutral = "neutral"
    case vibrant = "vibrant"
    case expressive = "expressive"
    case rainbow = "rainbow"
    case fruitSalad = "fruit_salad"
    case monochrome = "monochrome"
    case fidelity = "fidelity"
    case content = "content"
}

public enum AppearanceAccentColor: String, Codable, CaseIterable, Sendable {
    case system = "system"
    case blue = "blue"
    case purple = "purple"
    case pink = "pink"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case teal = "teal"
}

public enum AppearanceTopBarBlurStyle: String, Codable, CaseIterable, Sendable {
    case gaussian = "gaussian"
    case progressive = "progressive"
}

public struct AppearanceSettings: Codable, Hashable, Sendable {
    public var themeMode: AppearanceThemeMode
    public var monetEnabled: Bool
    public var paletteStyle: AppearancePaletteStyle
    public var accentColor: AppearanceAccentColor
    public var pureBlackEnabled: Bool
    public var blurEnabled: Bool
    public var topBarBlurStyle: AppearanceTopBarBlurStyle
    public var swipeDismissEnabled: Bool
    public var predictiveBackEnabled: Bool
    public var interfaceScale: Float

    public init(
        themeMode: AppearanceThemeMode = .system,
        monetEnabled: Bool = false,
        paletteStyle: AppearancePaletteStyle = .tonalSpot,
        accentColor: AppearanceAccentColor = .system,
        pureBlackEnabled: Bool = false,
        blurEnabled: Bool = true,
        topBarBlurStyle: AppearanceTopBarBlurStyle = .gaussian,
        swipeDismissEnabled: Bool = true,
        predictiveBackEnabled: Bool = true,
        interfaceScale: Float = AppearanceSettingsConsts.defaultInterfaceScale
    ) {
        self.themeMode = themeMode
        self.monetEnabled = monetEnabled
        self.paletteStyle = paletteStyle
        self.accentColor = accentColor
        self.pureBlackEnabled = pureBlackEnabled
        self.blurEnabled = blurEnabled
        self.topBarBlurStyle = topBarBlurStyle
        self.swipeDismissEnabled = swipeDismissEnabled
        self.predictiveBackEnabled = predictiveBackEnabled
        self.interfaceScale = interfaceScale
    }

    public func normalized() -> AppearanceSettings {
        var copy = self
        copy.interfaceScale = max(
            AppearanceSettingsConsts.minInterfaceScale,
            min(AppearanceSettingsConsts.maxInterfaceScale, interfaceScale)
        )
        return copy
    }
}
