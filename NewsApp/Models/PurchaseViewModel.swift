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
}
