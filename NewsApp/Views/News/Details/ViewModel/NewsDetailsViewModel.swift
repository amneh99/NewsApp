//
//  NewsDetailsViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import UIKit

class NewsDetailsViewModel {
    let news: Article
    private let imageLoader: ImageLoaderProtocol
    
    init(news: Article, imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.news = news
        self.imageLoader = imageLoader
    }
    
    var title: String {
        return news.title ?? ""
    }
    var description: String {
        return news.description ?? ""
    }
    var sourceName: String {
        return news.source?.name ?? ""
    }
    var author: String {
        return news.author ?? ""
    }
    var timeAgo: String? {
        return news.publishedAt?.relativeTimeAgo()
    }
    var imageURL: URL? {
        guard let urlString = news.urlToImage else { return nil }
        return URL(string: urlString)
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL else {
            completion(nil)
            return
        }
        
        imageLoader.loadImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}
