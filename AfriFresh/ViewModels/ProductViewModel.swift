import Foundation
import Combine

@MainActor
class ProductViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var searchText: String = "" {
        didSet { filterProducts() }
    }
    @Published var selectedCategory: String = "All" { // Use String for "All"
        didSet { filterProducts() }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        loadSampleProducts()
    }
    
    // MARK: - Load Sample Data
    func loadSampleProducts() {
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            
            await MainActor.run {
                self.products = Product.sampleProducts
                self.filteredProducts = Product.sampleProducts
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Filter Products
    func filterProducts() {
        filteredProducts = products.filter { product in
            // Category filter
            let matchesCategory = selectedCategory == "All" || product.category.displayName == selectedCategory
            
            // Search filter
            let matchesSearch = searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }
    }
    
    // MARK: - Add Product (Future Firebase Integration)
    func addProduct(_ product: Product) {
        products.append(product)
        filterProducts()
    }
    
    // MARK: - Error Handling
    func setError(_ message: String) {
        errorMessage = message
        isLoading = false
    }
    
    // MARK: - Helper: All categories + "All"
    var allCategories: [String] {
        ["All"] + ProductCategory.allCases.map { $0.displayName }
    }
}
