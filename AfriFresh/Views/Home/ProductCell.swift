import SwiftUI

struct ProductCell: View {
    let product: Product
    @EnvironmentObject var cartViewModel: CartViewModel

    // Current quantity in the cart
    var cartQuantity: Int {
        cartViewModel.items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // MARK: - Product Image
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .aspectRatio(1, contentMode: .fit)

                if let imageURL = product.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .padding(20)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if let localImage = product.images?.first {
                    Image(localImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .padding(20)
                }
            }

            // MARK: - Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)

                Text("UGX \(product.price, specifier: "%.0f")")
                    .font(.subheadline)
                    .foregroundColor(.green)

                Text("Farmer: \(product.farmerName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            // MARK: - Cart Controls
            if cartQuantity > 0 {
                // Show + / − buttons when already in cart
                HStack(spacing: 12) {
                    Button(action: {
                        if cartQuantity > 0 {
                            cartViewModel.updateQuantity(
                                for: CartItem(product: product, quantity: 1),
                                quantity: cartQuantity - 1
                            )
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }

                    Text("\(cartQuantity)")
                        .font(.headline)
                        .frame(minWidth: 24)

                    Button(action: {
                        cartViewModel.addToCart(product)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
                .padding(.top, 4)
            } else {
                // Initial "Add to Cart" button
                Button(action: {
                    cartViewModel.addToCart(product) // Automatically adds 1
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview(traits: .sizeThatFitsLayout) {
    let cartVM = CartViewModel()
    let sampleProduct = Product(
        id: "1",
        name: "Fresh Mango",
        description: "Sweet and juicy Ugandan mango.",
        category: .fruit,
        price: 3000,
        images: ["mango"],
        farmerName: "John Doe"
    )

    ProductCell(product: sampleProduct)
        .environmentObject(cartVM)
        .padding()
}
