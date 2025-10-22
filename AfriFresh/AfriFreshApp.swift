import SwiftUI
import FirebaseCore

// MARK: - AppDelegate for Firebase Setup
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        print("⚡ AfriFresh App initialized successfully")
        return true
    }
}

@main
struct AfriFreshApp: App {
    
    // MARK: - Register AppDelegate (for Firebase)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - Global App State
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var orderViewModel = OrderViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStore)
                .environmentObject(authViewModel)
                .environmentObject(orderViewModel)
                .onAppear {
                    print("📱 AfriFreshApp launched - Authenticated: \(authViewModel.isAuthenticated)")
                }
        }
    }
}
