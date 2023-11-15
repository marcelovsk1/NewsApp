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
    @Published private var subscriptions: [Product] = []
    @Published private var purchasedSubscriptions: [Product] = []
    @Published private var subscriptionGroupStatus: RenewalState?
    
    private let productsIds: [String] = ["subscription.yearly", "subscription.monthly"]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    // init
    // denit
    
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
                    
                } catch {
                    
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
}

enum StoreError: Error {
    case failedVerification
}
