//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import Foundation
import Combine

class NewsViewModel {
    var articles: [Article] = []
    var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    var newsRepository: NewsRepositoryProtocol
    
    init() {
        newsRepository = NewsRepository()
        addNetworkObserver()
    }
    
    func addNetworkObserver() {
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
    
    func getTopHeadlines() async {
        if NetworkMonitor.shared.isConnected {
            await fetchTopHeadlines()
        } else {
            getArticlesFromCoreData()
        }
    }
    
    private func fetchTopHeadlines() async {
        do {
            let articles = try await newsRepository.getTopHeadlines()
            self.articles = articles
            saveArticlesInCoreData()
            error = nil
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknownError(0)
        }
    }
    
    func saveArticlesInCoreData() {
        guard !articles.isEmpty else { return }
        DataManager.shared.newsArticles = articles
    }
    
    func getArticlesFromCoreData() {
        articles = DataManager.shared.newsArticles ?? []
    }
}
