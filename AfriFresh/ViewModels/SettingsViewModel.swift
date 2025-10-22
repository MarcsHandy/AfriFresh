import SwiftUI
import Combine

// MARK: - Theme Model
struct AppTheme: Codable, Equatable {
    var name: String
    var backgroundColorHex: String
    var textColorHex: String
    var accentColorHex: String
    
    // Computed SwiftUI Colors
    var backgroundColor: Color { Color(hex: backgroundColorHex) }
    var textColor: Color { Color(hex: textColorHex) }
    var accentColor: Color { Color(hex: accentColorHex) }
    
    // Predefined themes
    static let light = AppTheme(
        name: "Light",
        backgroundColorHex: "#FFFFFF",
        textColorHex: "#000000",
        accentColorHex: "#34C759" // green
    )
    
    static let dark = AppTheme(
        name: "Dark",
        backgroundColorHex: "#000000",
        textColorHex: "#FFFFFF",
        accentColorHex: "#34C759" // green
    )
}

// MARK: - Settings Store (ViewModel)
final class SettingsStore: ObservableObject {
    // Published theme and appearance
    @Published var currentTheme: AppTheme = .light {
        didSet { saveTheme() }
    }
    @Published var isDarkMode: Bool = false {
        didSet { toggleTheme(isDarkMode: isDarkMode) }
    }
    
    // Other user preferences
    @Published var preferredCurrency: String = "UGX"
    @Published var deliveryNotificationsEnabled: Bool = true
    @Published var soundEffectsEnabled: Bool = true
    
    // Hamburger Menu
    @Published var showMenu: Bool = false
    
    private let themeKey = "selectedTheme"
    
    // MARK: - Init
    init() {
        loadTheme()
    }
    
    // MARK: - Theme Handling
    private func toggleTheme(isDarkMode: Bool) {
        currentTheme = isDarkMode ? .dark : .light
    }
    
    private func saveTheme() {
        do {
            let data = try JSONEncoder().encode(currentTheme)
            UserDefaults.standard.set(data, forKey: themeKey)
        } catch {
            print("⚠️ Failed to save theme: \(error.localizedDescription)")
        }
    }
    
    private func loadTheme() {
        guard let data = UserDefaults.standard.data(forKey: themeKey),
              let theme = try? JSONDecoder().decode(AppTheme.self, from: data) else {
            currentTheme = .light
            isDarkMode = false
            return
        }
        currentTheme = theme
        isDarkMode = (theme == .dark)
    }
    
    // MARK: - Reset Preferences
    func resetSettings() {
        isDarkMode = false
        preferredCurrency = "UGX"
        deliveryNotificationsEnabled = true
        soundEffectsEnabled = true
        currentTheme = .light
        saveTheme()
    }
}
