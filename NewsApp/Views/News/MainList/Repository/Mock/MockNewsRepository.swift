//
//  MockNewsRepository.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Foundation

final class MockNewsRepository: NewsArticlesRepositoryProtocol {
    
    var mockArticles: [Article] = []
    var shouldThrowError = false
    var error: Error = NetworkError.invalidResponse
    
    func fetchTopHeadlines() async throws -> [Article] {
        if shouldThrowError {
            throw error
        }
        return mockArticles
    }
}
