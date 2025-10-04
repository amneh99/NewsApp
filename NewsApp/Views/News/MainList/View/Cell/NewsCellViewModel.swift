//
//  NewsCellViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import UIKit

class NewsCellViewModel {
    let title: String
    let source: String
    let imageURL: String?
    let timeAgo: String?
    
    init(article: Article) {
        title = article.title?.nonEmpty ?? "No title available"
        source = article.source?.name?.nonEmpty ?? "Unknown source"
        imageURL = article.urlToImage
        timeAgo = article.publishedAt?.relativeTimeAgo()
    }
}
