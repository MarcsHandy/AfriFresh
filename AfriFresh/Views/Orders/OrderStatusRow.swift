import SwiftUI

struct OrderStatusRow: View {
    let order: Order  // Make sure Order is defined in Models/Order.swift
    
    var body: some View {
        HStack(spacing: 16) {
            // Status Indicator
            Circle()
                .fill(statusColor(order.status))
                .frame(width: 16, height: 16)
            
            // Order Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Order #\(order.id)")
                    .font(.headline)
                
                Text("Placed on \(formattedDate(order.createdAt))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Status: \(order.status.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(statusColor(order.status))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Helpers
    
    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .confirmed: return .blue
        case .outForDelivery: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview(traits: .sizeThatFitsLayout) {
    let sampleOrder = Order(
        userId: "user123",
        items: [
            OrderItem(productId: "prod1", name: "Tomatoes", quantity: 2, price: 1.5),
            OrderItem(productId: "prod2", name: "Bananas", quantity: 3, price: 0.8)
        ],
        deliveryAddress: "123 Kampala St."
    )
    
    OrderStatusRow(order: sampleOrder)
        .padding()
}
