//
//  PurchaseViewModel.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-15.
//

import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalInfo

class PurchaseViewModel: ObservableObject {
    @Published var subscriptions: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []
    @Published var subscriptionGroupStatus: RenewalState?
    
    private let productsIds: [String] = ["subscription.yearly", "subscription.monthly"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updateCustomerProduct()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func requestProducts() async {
        do {
            subscriptions = try await Product.products(for: productsIds)
        } catch {
            print("Failed product request from app store sever \(error)")
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProduct()
                    
                    await transaction.finish()
                } catch {
                    print("Transation failed verification")
                }
            }
        }
        
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProduct() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                switch transaction.productType {
                case .autoRenewable:
                    if let subscriptions = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscriptions)
                    }
                default:
                    break
                }
                await transaction.finish()
            } catch {
                print("Failed updating products")
            }
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            do {
                let transaction = try checkVerified(verification)
                await updateCustomerProduct()
                await transaction.finish()
                return transaction
            } catch {
                print("Failed finishing transaction: \(error)")
                return nil
            }
        case .userCancelled, .pending:
            return nil
        default:
            return nil
                
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
