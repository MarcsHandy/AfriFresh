import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Combine

final class FirebaseService: ObservableObject {

    static let shared = FirebaseService() // Singleton for global access

    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // MARK: - Authentication

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "AfriFresh", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }

            // Fetch additional user info from Firestore
            self?.db.collection("users").document(firebaseUser.uid).getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let snapshot = snapshot, let data = try? snapshot.data(as: User.self) {
                    completion(.success(data))
                } else {
                    // Fallback: create a minimal User struct from FirebaseAuth.User
                    let user = User(
                        id: firebaseUser.uid,
                        fullName: firebaseUser.displayName ?? "",
                        email: firebaseUser.email ?? "",
                        phoneNumber: firebaseUser.phoneNumber,
                        address: nil,
                        createdAt: firebaseUser.metadata.creationDate,
                        orderIDs: []
                    )
                    completion(.success(user))
                }
            }
        }
    }

    func signUp(fullName: String, email: String, password: String, phoneNumber: String? = nil, address: String? = nil, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "AfriFresh", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }

            // Create AfriFresh.User
            let user = User(
                id: firebaseUser.uid,
                fullName: fullName,
                email: email,
                phoneNumber: phoneNumber,
                address: address,
                createdAt: Date(),
                orderIDs: []
            )

            // Save to Firestore
            do {
                try self?.db.collection("users").document(firebaseUser.uid).setData(from: user)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func signOut() throws {
        try auth.signOut()
    }

    func currentUser() -> User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return User(
            id: firebaseUser.uid,
            fullName: firebaseUser.displayName ?? "",
            email: firebaseUser.email ?? "",
            phoneNumber: firebaseUser.phoneNumber,
            address: nil,
            createdAt: firebaseUser.metadata.creationDate,
            orderIDs: []
        )
    }

    // MARK: - Products

    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let products: [Product] = documents.compactMap { doc in
                try? doc.data(as: Product.self)
            }
            completion(.success(products))
        }
    }

    func addProduct(_ product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try db.collection("products").addDocument(from: product)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Orders

    func placeOrder(_ order: Order, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try db.collection("orders").addDocument(from: order)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchOrders(for userId: String, completion: @escaping (Result<[Order], Error>) -> Void) {
        db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }

                let orders: [Order] = documents.compactMap { doc in
                    try? doc.data(as: Order.self)
                }
                completion(.success(orders))
            }
    }

    // MARK: - Images

    func uploadImage(_ imageData: Data, path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = storage.reference(withPath: path)
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
}
