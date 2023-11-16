//
//  SettingsView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject var purchaseViewModel = PurchaseViewModel()
    @AppStorage("purchased") var purchased = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func buy(product: Product) async {
        do {
            if try await purchaseViewModel.purchase(product) != nil {
                purchased = true
            }
        } catch {
            print("Purchased failed")
        }
    }
}

#Preview {
    SettingsView()
}
