import SwiftUI

struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
            
            Text("Oops!")
                .font(.title)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 10)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ErrorView(message: "Unable to load products. Please check your internet connection.")
        
        ErrorView(message: "Login failed. Please try again.") {
            print("Retry tapped!")
        }
    }
    .padding()
}

