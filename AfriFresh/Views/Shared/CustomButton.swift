import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    var backgroundColor: Color? = nil
    var foregroundColor: Color = .white
    var isLoading: Bool = false
    var cornerRadius: CGFloat = 10
    var padding: CGFloat = 16

    @EnvironmentObject var settingsStore: SettingsStore

    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            ZStack {
                // Button background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor ?? settingsStore.currentTheme.accentColor)
                    .frame(maxWidth: .infinity)
                
                // Button content
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(foregroundColor)
                        .padding(padding)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        CustomButton(title: "Sign In") {
            print("Sign In tapped")
        }
        CustomButton(
            title: "Sign Up",
            action: {
                print("Sign Up tapped")
            },
            backgroundColor: .gray
        )
        CustomButton(
            title: "Loading Button",
            action: {
                print("This won't trigger while loading")
            },
            isLoading: true
        )
    }
    .padding()
    .environmentObject(SettingsStore())
}

