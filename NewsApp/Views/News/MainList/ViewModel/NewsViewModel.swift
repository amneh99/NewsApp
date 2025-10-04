//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import Foundation
import Combine

class NewsViewModel {
    @Published private(set) var state: ViewState = .idle
    var articles: [Article] = []
    
    private var cancellables = Set<AnyCancellable>()
    var repository: NewsArticlesRepositoryProtocol
    private var dataManager: DataManaging
    
    init(repository: NewsArticlesRepositoryProtocol = NewsArticlesRepository(), dataManager: DataManaging = DataManager.shared) {
        self.repository = repository
        self.dataManager = dataManager
        observeNetworkChanges()
    }
    
    func observeNetworkChanges() {
        NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    Task { await self.fetchTopHeadlines() }
                } else {
                    self.getArticlesFromCoreData()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchTopHeadlines() async {
        state = .loading
        do {
            let fetchedArticles = try await repository.fetchTopHeadlines()
            await MainActor.run {
                self.articles = fetchedArticles
                saveArticlesInCoreData()
                self.state = .loaded
            }
        } catch {
            await MainActor.run {
                self.getArticlesFromCoreData()
                if self.articles.isEmpty {
                    self.state = .error(error)
                } else {
                    self.state = .loaded
                }
            }
        }
    }
    
    func saveArticlesInCoreData() {
        guard !articles.isEmpty else { return }
        dataManager.newsArticles = articles
    }
    
    func getArticlesFromCoreData() {
        articles = dataManager.newsArticles ?? []
    }
}
