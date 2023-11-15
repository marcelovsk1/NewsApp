//
//  NewsView.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI

struct NewsView: View {
    var newsManager = NewsManager()
    @State private var articles = [NewsResponse.Article]()
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if isLoading != true {
                        ForEach(articles) { article in
                            let type = predictSentement(text: article.title)
                            
                            NavigationLink {
                                ArticleView(article: article)
                                
                            } label: {
                                NewsCardComponent(article: article, type: type ?? "Neutral")
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("News Feed")
            .preferredColorScheme(.dark)
            .onAppear {
                newsManager.getNews(category: "general") { newsResponse in
                    articles = newsResponse
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
