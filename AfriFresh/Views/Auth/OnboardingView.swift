import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var currentPage = 0
    
    // MARK: - Onboarding Data
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboard_fruit",
            title: "Fresh Local Produce",
            description: "Get farm-fresh fruits and vegetables delivered straight to your door."
        ),
        OnboardingPage(
            imageName: "onboard_market",
            title: "Support Local Farmers",
            description: "Buy directly from local farmers and markets across Uganda."
        ),
        OnboardingPage(
            imageName: "onboard_delivery",
            title: "Fast Delivery",
            description: "Track your order and enjoy fresh produce without leaving home."
        )
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // MARK: - Image
            Image(pages[currentPage].imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
            
            // MARK: - Title & Description
            VStack(spacing: 10) {
                Text(pages[currentPage].title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(settingsStore.currentTheme.textColor)
                
                Text(pages[currentPage].description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // MARK: - Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? settingsStore.currentTheme.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            
            // MARK: - Buttons
            Button(action: {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    // Navigate to LoginView
                    authViewModel.showOnboarding = false
                }
            }) {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(settingsStore.currentTheme.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(settingsStore.currentTheme.backgroundColor)
        .animation(.easeInOut, value: currentPage)
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var description: String
}

// MARK: - Preview
#Preview {
    let settingsStore = SettingsStore()
    let authViewModel = AuthViewModel()
    
    OnboardingView()
        .environmentObject(settingsStore)
        .environmentObject(authViewModel)
}

