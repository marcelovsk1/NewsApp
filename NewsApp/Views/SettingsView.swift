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
                    
                    Text("Unlock all features with a subscription.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Button {
                            Task {
                                let viewModel = purchaseViewModel
                                await buy(product: viewModel.subscriptions[1])
                            }
                        } label: {
                            VStack {
                                Text("Monthly")
                                    .font(.headline)
                                Text("5.90/Month")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Button {
                            Task {
                                await buy(product: purchaseViewModel.subscriptions.first!)
                            }
                        } label: {
                            VStack {
                                Text("Yearly")
                                    .font(.headline)
                                Text("29.90/Year")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                        
                    Spacer()
                        
                    Text("By subscribing, you agree to the terms of use and privacy policy.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                        
                }
                .padding()
                .preferredColorScheme(.dark)
            } else {
                Form {
                    
                }
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
