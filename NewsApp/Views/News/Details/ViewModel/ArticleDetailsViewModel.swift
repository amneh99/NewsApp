//
//  ArticleDetailsViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import UIKit

class ArticleDetailsViewModel {
    let title: String
    let description: String
    let sourceName: String
    let author: String
    let timeAgo: String?
    let imageURL: String?
    
    init(article: Article) {
        title = article.title?.nonEmpty ?? "No title available"
        description = article.description?.nonEmpty ?? article.content?.nonEmpty ?? "No description available"
        sourceName = article.source?.name?.nonEmpty ?? "Unknown source"
        author = article.author?.nonEmpty ?? "Unknown author"
        timeAgo = article.publishedAt?.relativeTimeAgo()
        imageURL = article.urlToImage
    }
}
