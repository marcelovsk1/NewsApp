//
//  ContentView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NewsView()
            .tag(1)
        
            SearchView()
                .tag(2)
            
            SettingsView()
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
