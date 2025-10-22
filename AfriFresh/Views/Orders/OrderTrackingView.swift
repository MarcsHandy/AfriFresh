import SwiftUI

struct OrderTrackingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if orderViewModel.recentOrders.isEmpty {
                    Text("You have no orders yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(orderViewModel.recentOrders) { order in
                            OrderRowView(order: order)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("My Orders")
            .onAppear {
                if let userId = authViewModel.user?.id {
                    orderViewModel.fetchOrders(for: userId)
                }
            }
        }
    }
}

// MARK: - Order Row View
struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.id.prefix(6))")
                    .font(.headline)
                Spacer()
                Text(order.status.rawValue)
                    .font(.subheadline)
                    .foregroundColor(color(for: order.status))
                    .padding(6)
                    .background(color(for: order.status).opacity(0.2))
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(order.items, id: \.id) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("x\(item.quantity)")
                    }
                }
            }
            
            ProgressView(value: progressValue(for: order.status))
                .accentColor(color(for: order.status))
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Helpers
    private func progressValue(for status: OrderStatus) -> Double {
        switch status {
        case .pending: return 0.2
        case .confirmed: return 0.5
        case .outForDelivery: return 0.8
        case .delivered: return 1.0
        case .cancelled: return 0.0
        }
    }
    
    private func color(for status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .confirmed: return .blue
        case .outForDelivery: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}

// MARK: - Preview
#Preview("Out For Delivery") {
    OrderTrackingView()
        .environmentObject(AuthViewModel())
        .environmentObject(OrderViewModel.preview)
}
