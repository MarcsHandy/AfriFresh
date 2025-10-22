import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // MARK: - User Info
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(settingsStore.currentTheme.accentColor)
                    
                    Text(authViewModel.user?.email ?? "Guest")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Welcome to AfriFresh!")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Divider()
                
                // MARK: - Profile Options
                List {
                    Section(header: Text("Account")) {
                        NavigationLink(destination: EditProfileView()) {
                            Label("Edit Profile", systemImage: "pencil")
                        }
                        
                        NavigationLink(destination: OrderTrackingView()) {
                            Label("My Orders", systemImage: "bag.fill")
                        }
                    }
                    
                    Section(header: Text("Settings")) {
                        Toggle(isOn: $settingsStore.isDarkMode) {
                            Label("Dark Mode", systemImage: "moon.fill")
                        }
                    }
                    
                    Section {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign Out")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Preview

#Preview {
    let authVM = AuthViewModel()
    authVM.isAuthenticated = true
    let settings = SettingsStore()
    
    return ProfileView()
        .environmentObject(authVM)
        .environmentObject(settings)
}

