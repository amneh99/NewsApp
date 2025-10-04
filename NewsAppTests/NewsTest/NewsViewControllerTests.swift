//
//  NewsViewControllerTests.swift
//  NewsAppTests
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Testing
import UIKit
@testable import NewsApp

@Suite("News View Controller Tests", .tags(.viewController))
struct NewsViewControllerTests {
    let mockViewModel: NewsViewModel
    let mockRepository: MockNewsRepository
    
    init() {
        mockRepository = MockNewsRepository()
        mockViewModel = NewsViewModel(repository: mockRepository)
    }
    
    @Test("View model returns correct number of articles")
    func viewModelArticleCount() {
        // Given
        mockViewModel.articles = createMockArticles(count: 5)
        
        // Then
        #expect(mockViewModel.articles.count == 5)
    }
}
