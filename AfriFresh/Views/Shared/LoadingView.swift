import SwiftUI

struct LoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Spinner and message
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text(message)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(Color.black.opacity(0.7))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
        LoadingView(message: "Fetching products...")
    }
}

