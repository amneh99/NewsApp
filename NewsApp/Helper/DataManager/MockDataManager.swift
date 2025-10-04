//
//  MockDataManager.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Foundation

final class MockDataManager: DataManaging {
    var newsArticles: [Article]?
    
    init(newsArticles: [Article]? = nil) {
        self.newsArticles = newsArticles
    }
}
