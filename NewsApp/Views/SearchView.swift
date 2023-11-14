//
//  SearchView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-14.
//

import SwiftUI

struct SearchView: View {
    var newsManager = NewsManager()
    @State private var selectedGenre = "general"
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var articles = [NewsResponse.Article]()
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private func updateNewsArticles() {
        newsManager.getNews(category: selectedGenre) { newsResponse in
            articles = newsResponse
            isLoading = false
        }
    }
}

#Preview {
    SearchView()
}
