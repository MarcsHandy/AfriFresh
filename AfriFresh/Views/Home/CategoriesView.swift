import SwiftUI

struct CategoriesView: View {
    @Binding var selectedCategory: String
    
    // Example categories for AfriFresh
    let categories = ["All", "Fruits", "Vegetables", "Herbs", "Other"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .fontWeight(selectedCategory == category ? .bold : .regular)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedCategory == category ? Color.green.opacity(0.8) : Color.gray.opacity(0.2))
                            )
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var selected = "All"
    return CategoriesView(selectedCategory: $selected)
}

