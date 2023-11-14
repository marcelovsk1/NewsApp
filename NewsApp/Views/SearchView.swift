//
//  SearchView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI

struct SearchView: View {
    var newsManager = NewsManager()
    @State private var selectedGenre = "general"
    @State private var isLoading = true
    @State private var searchText = ""
    @State private var articles = [NewsResponse.Article]()
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search...", text: $searchText)
                        .padding(.leading, 20)
                    
                    if searchText.isEmpty {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    } else {
                        Button {
                            searchText = ""
                            updateNewsArticles()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                if searchText == "" {
                    Picker("Picker", selection: $selectedGenre) {
                        Text("General").tag("general")
                        Text("Business").tag("business")
                        Text("Entertaiment").tag("entertaiment")
                        Text("Sports").tag("sports")
                        Text("Science").tag("science")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 15)
                }
                
                ScrollView {
                    if isLoading != true {
                        ForEach(articles) { article in
                            NewsCardComponent(article: article)

                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .onAppear(perform: updateNewsArticles)
            .onChange(of: selectedGenre) { newValue in
                isLoading = true
                updateNewsArticles()
            }
            .onChange(of: searchText) { newValue in
                 isLoading = true
                 updateNewsArticles()
            }
        }
    }
    
    private func updateNewsArticles() {
        newsManager.getNews(category: selectedGenre) { newsResponse in
            articles = newsResponse
            isLoading = false
        }
    }
    
    private func updateNewsArticlesFromSearch() {
        newsManager.getNews(category: searchText) { newsResponse in
            articles = newsResponse
            isLoading = false
        }
    }
}

#Preview {
    SearchView()
}
