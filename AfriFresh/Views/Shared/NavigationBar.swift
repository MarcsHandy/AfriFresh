import SwiftUI

struct AppNavigationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // MARK: - Home / Product Feed
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(Tab.home)
            
            // MARK: - Cart
            CartView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }
                .tag(Tab.cart)
            
            // MARK: - Orders
            OrderTrackingView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Orders")
                }
                .tag(Tab.orders)
            
            // MARK: - Profile / Settings
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(Tab.profile)
        }
        .accentColor(settingsStore.currentTheme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tabs Enum
extension AppNavigationView {
    enum Tab: Hashable {
        case home, cart, orders, profile
    }
}

// MARK: - Preview
#Preview {
    let settingsStore = SettingsStore()
    let authViewModel = AuthViewModel()
    
    AppNavigationView()
        .environmentObject(settingsStore)
        .environmentObject(authViewModel)
}

