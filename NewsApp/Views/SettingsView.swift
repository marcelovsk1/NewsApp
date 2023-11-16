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
        NavigationView {
            if purchased == false {
                VStack {
                    Text("Subscribe to access settings")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Spacer()
                    
                    Image(systemName: "lock.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.bottom)
                    
                    
                }
                .padding()
                .preferredColorScheme(.dark)
            } else {
                
            }
        }
        .task {
            if purchaseViewModel.purchasedSubscriptions.isEmpty {
                purchased = false
            } else {
                purchased = true
            }
        }
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
