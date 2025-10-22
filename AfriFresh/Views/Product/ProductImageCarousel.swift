import SwiftUI

struct ProductImageCarousel: View {
    let images: [String] // Array of image URLs or asset names
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            if images.isEmpty {
                // Placeholder if no images
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(12)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 250)
                
                // Page indicators
                HStack(spacing: 6) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? Color.green : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
}

// MARK: - Preview with sample data
#Preview {
    ProductImageCarousel(images: ["apple", "banana", "tomato"])
        .frame(height: 280)
        .padding()
}

