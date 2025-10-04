//
//  NewsArticlesRepositoryTests.swift
//  NewsAppTests
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Testing
import UIKit
@testable import NewsApp

@Suite("News Articles Repository Tests", .tags(.repository))
struct NewsArticlesRepositoryTests {
    var sut: NewsArticlesRepository
    var mockNetworkManager: MockNetworkManager
    
    init() {
        mockNetworkManager = MockNetworkManager()
        sut = NewsArticlesRepository(networkManager: mockNetworkManager)
    }
    
    @Test("Fetch top headlines returns articles on success")
    func fetchTopHeadlinesSuccess() async throws {
        // Given
        let mockResponse = APIResponse<Article>(
            status: "ok",
            totalResults: 2,
            articles: createMockArticles(count: 2)
        )
        mockNetworkManager.mockData = try JSONEncoder().encode(mockResponse)
        
        // When
        let articles = try await sut.fetchTopHeadlines()
        
        // Then
        #expect(articles.count == 2)
    }
    
    @Test("Fetch top headlines throws error on failure")
    func fetchTopHeadlinesFailure() async throws {
        // Given
        mockNetworkManager.mockError = NetworkError.invalidResponse
        
        // When/Then
        await #expect(throws: NetworkError.self) {
            try await sut.fetchTopHeadlines()
        }
    }
}
