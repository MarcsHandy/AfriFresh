import Foundation
import Combine

/// Handles mobile money payments (MTN & Airtel)
/// For MVP, this version simulates payment success/failure and delays to mimic network calls.

class PaymentService: ObservableObject {
    enum PaymentProvider: String, CaseIterable, Identifiable {
        case mtn = "MTN Mobile Money"
        case airtel = "Airtel Money"
        
        var id: String { rawValue }
        var logoName: String {
            switch self {
            case .mtn: return "mtn_logo" // Add to Assets.xcassets
            case .airtel: return "airtel_logo"
            }
        }
    }
    
    enum PaymentStatus {
        case idle
        case processing
        case success(String)   // message
        case failure(String)   // error message
    }
    
    // MARK: - Published State
    @Published var status: PaymentStatus = .idle
    @Published var selectedProvider: PaymentProvider = .mtn
    @Published var lastTransactionID: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public Methods
    
    /// Simulates a mobile money payment
    func pay(amount: Double, phoneNumber: String) {
        guard !phoneNumber.isEmpty else {
            status = .failure("Please enter your mobile number.")
            return
        }
        
        status = .processing
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            guard let self = self else { return }
            
            let success = Bool.random() // Random success for demo
            let txID = UUID().uuidString.prefix(8)
            
            if success {
                self.lastTransactionID = String(txID)
                self.status = .success("Payment successful via \(self.selectedProvider.rawValue) (Ref: \(txID))")
                print("✅ Payment success via \(self.selectedProvider.rawValue) | TX: \(txID)")
            } else {
                self.status = .failure("Payment failed. Please try again or use another method.")
                print("❌ Payment failed via \(self.selectedProvider.rawValue)")
            }
        }
    }
    
    /// Resets payment state
    func reset() {
        status = .idle
        lastTransactionID = nil
    }
}

