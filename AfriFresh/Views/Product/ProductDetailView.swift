import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var cartViewModel: CartViewModel
    
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Product Images
                if let images = product.images, !images.isEmpty {
                    TabView {
                        ForEach(images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .cornerRadius(12)
                        .overlay(
                            Text("No image available")
                                .foregroundColor(.white)
                        )
                }
                
                // MARK: - Product Info
                VStack(alignment: .leading, spacing: 12) {
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(settingsStore.currentTheme.textColor)
                    
                    Text("Sold by: \(product.farmerName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(settingsStore.currentTheme.textColor)
                    
                    Text("UGX \(product.price, specifier: "%.0f")")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(settingsStore.currentTheme.accentColor)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Add to Cart Button
                Button(action: {
                    cartViewModel.addToCart(product)
                    print("🛒 Added to cart: \(product.name). Total items: \(cartViewModel.items.count)")
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(settingsStore.currentTheme.accentColor)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#Preview {
    let settingsStore = SettingsStore()
    let cartVM = CartViewModel()
    
    ProductDetailView(product: Product.sampleProducts[0])
        .environmentObject(settingsStore)
        .environmentObject(cartVM)
}
