//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import Foundation

protocol NewsRepositoryProtocol {
    func getTopHeadlines() async throws -> [Article]
}

final class NewsRepository: NewsRepositoryProtocol {
    private let networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getTopHeadlines() async throws -> [Article] {
        let endpoint = NewsEndpoint.topHeadlines(country: "us")
        let response: APIResponse<Article> = try await networkManager.fetch(from: endpoint)
        return response.articles ?? []
    }
}
