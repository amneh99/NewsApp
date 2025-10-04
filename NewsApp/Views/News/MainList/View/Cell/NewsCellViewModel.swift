//
//  NewsCellViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import UIKit

class NewsCellViewModel {
    private let article: Article
    private let imageLoader: ImageLoaderProtocol
    
    // MARK: - Public Interface
    var title: String {
        return article.title ?? ""
    }
    
    var source: String {
        return article.source?.name ?? ""
    }
    
    var imageURL: URL? {
        guard let urlString = article.urlToImage else { return nil }
        return URL(string: urlString)
    }
    
    var timeAgo: String? {
        return article.publishedAt?.relativeTimeAgo()
    }
    
    init(article: Article, imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.article = article
        self.imageLoader = imageLoader
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

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Check cache first
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(.success(cachedImage))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "ImageLoader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
                return
            }
            
            // Cache the image
            self?.cache.setObject(image, forKey: url as NSURL)
            completion(.success(image))
        }
        task.resume()
    }
}
