//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import Foundation

protocol NewsArticlesRepositoryProtocol {
    func fetchTopHeadlines() async throws -> [Article]
}

final class NewsArticlesRepository: NewsArticlesRepositoryProtocol {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchTopHeadlines() async throws -> [Article] {
        let endpoint = NewsArticlesEndpoint(country: "us")
        let response: APIResponse<Article> = try await networkManager.fetch(from: endpoint)
        return response.articles ?? []
    }
}

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
