//
//  NewsViewModelTests.swift
//  NewsAppTests
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Testing
import Combine
import SwiftUI
@testable import NewsApp

@Suite("News View Model Tests", .tags(.viewModel))
struct NewsViewModelTests {
    let mockRepository: MockNewsRepository
    let mockDataManager: MockDataManager
    let sut: NewsViewModel
    
    init() {
        mockRepository = MockNewsRepository()
        mockDataManager = MockDataManager()
        sut = NewsViewModel(repository: mockRepository, dataManager: mockDataManager)
    }
    
    @Test("Fetch top headlines successfully updates articles and state")
    func fetchTopHeadlinesSuccess() async throws {
        // Given
        let expectedArticles = createMockArticles(count: 3)
        mockRepository.mockArticles = expectedArticles
        
        var receivedStates: [ViewState] = []
        var cancellables = Set<AnyCancellable>()
        
        sut.$state
            .sink { state in
                receivedStates.append(state)
            }
            .store(in: &cancellables)
        
        // When
        await sut.fetchTopHeadlines()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(sut.articles.count == 3)
        #expect(receivedStates.contains { if case .loading = $0 { return true }; return false })
        #expect(receivedStates.contains { if case .loaded = $0 { return true }; return false })
    }
    
    @Test("Fetch top headlines saves to Core Data on success")
    func fetchTopHeadlinesSavesToCoreData() async throws {
        // Given
        let expectedArticles = createMockArticles(count: 2)
        mockRepository.mockArticles = expectedArticles
        
        // When
        await sut.fetchTopHeadlines()
        
        // Then
        #expect(sut.articles.count == 2)
        #expect(mockDataManager.newsArticles?.count == 2)
    }
    
    @Test("Fetch failure with no cached data returns error state")
    func fetchTopHeadlinesFailureWithNoCachedData() async throws {
        // Given
        DataManager.shared.newsArticles = nil
        
        mockRepository.shouldThrowError = true
        mockRepository.error = NetworkError.serverError(500)
        
        var receivedError: Error?
        var cancellables = Set<AnyCancellable>()
        
        sut.$state
            .sink { state in
                if case .error(let error) = state {
                    receivedError = error
                }
            }
            .store(in: &cancellables)
        
        // When
        await sut.fetchTopHeadlines()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(receivedError != nil)
        #expect(sut.articles.isEmpty)
    }
    
    @Test("Fetch failure with cached data loads cached articles")
    func fetchTopHeadlinesFailureWithCachedData() async throws {
        // Given
        let cachedArticles = createMockArticles(count: 2)
        mockDataManager.newsArticles = cachedArticles
        
        mockRepository.shouldThrowError = true
        
        var stateLoaded = false
        var cancellables = Set<AnyCancellable>()
        
        sut.$state
            .sink { state in
                if case .loaded = state {
                    stateLoaded = true
                }
            }
            .store(in: &cancellables)
        
        // When
        await sut.fetchTopHeadlines()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(sut.articles.count == 2)
        #expect(stateLoaded == true)
    }
    
    @Test("Initial state is idle")
    func initialStateIsIdle() {
        // Given
        let viewModel = NewsViewModel(repository: mockRepository, dataManager: mockDataManager)
        
        // Then
        if case .idle = viewModel.state {
            #expect(Bool(true))
        } else {
            Issue.record("Initial state should be idle")
        }
    }
    
    @Test("Fetch sets loading state")
    func fetchSetsLoadingState() async throws {
        // Given
        mockRepository.mockArticles = createMockArticles(count: 1)
        
        var loadingStateSet = false
        var cancellables = Set<AnyCancellable>()
        
        sut.$state
            .sink { state in
                if case .loading = state {
                    loadingStateSet = true
                }
            }
            .store(in: &cancellables)
        
        // When
        await sut.fetchTopHeadlines()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(loadingStateSet == true)
    }
    
    @Test("Save articles with empty list does not save")
    func saveEmptyArticles() {
        // Given
        sut.articles = []
        mockDataManager.newsArticles = nil
        
        // When
        sut.saveArticlesInCoreData()
        
        // Then
        #expect(mockDataManager.newsArticles == nil)
    }
    
    @Test("Get articles from Core Data loads cached articles")
    func getArticlesFromCoreData() {
        // Given
        let cachedArticles = createMockArticles(count: 3)
        mockDataManager.newsArticles = cachedArticles
        
        // When
        sut.getArticlesFromCoreData()
        
        // Then
        #expect(sut.articles.count == 3)
    }
    
    @Test("Get articles from Core Data with no cache returns empty")
    func getArticlesFromCoreDataWithNoCache() {
        // Given
        mockDataManager.newsArticles = nil
        
        // When
        sut.getArticlesFromCoreData()
        
        // Then
        #expect(sut.articles.isEmpty)
    }
}

