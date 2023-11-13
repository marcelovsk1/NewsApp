//
//  NewsCardComponent.swift
//  NewsApp
//
//  Created by Marcelo Amaral Alves on 2023-11-13.
//

import SwiftUI

struct NewsCardComponent: View {
    var article: NewsResponse.Article
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
        }
        .padding(4)
        .frame(maxWidth: .infinity, maxHeight: 230, alignment: .leading)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

#Preview {
    NewsCardComponent(article: NewsResponse.Article(title: "", url: ""))
}
