//
//  CostomTabView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI

struct CostomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var AnimationNameSpace
    
    let tabBaritems: [(image: String, title: String)] = [("newspaper.fill", "News"), ("magnifyingglass", "Search"), ("gear", "Settings")]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CostomTabView(tabSelection: .constant(1))
}
