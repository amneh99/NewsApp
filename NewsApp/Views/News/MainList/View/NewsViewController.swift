//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit
import Combine

class NewsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let viewModel = NewsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        bindViewModel()
        Task {
            await fetchHeadlines()
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: ViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            if !refreshControl.isRefreshing {
                showLoading()
            }
        case .loaded:
            hideLoading()
            refreshControl.endRefreshing()
            tableView.reloadData()
            tableView.setBackground(state: viewModel.articles.isEmpty ? .empty : .normal)
        case .error(let error):
            hideLoading()
            refreshControl.endRefreshing()
            showErrorAlert(message: error.localizedDescription)
            tableView.setBackground(state: viewModel.articles.isEmpty ? .empty : .normal)
        }
    }
    
    func fetchHeadlines() async {
        Task {
            await viewModel.fetchTopHeadlines()
        }
    }
    
    @objc private func refreshData() {
        Task {
            await fetchHeadlines()
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate extension
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsArticleCell", for: indexPath) as? NewsArticleCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = NewsCellViewModel(article: viewModel.articles[indexPath.row])
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController {
            let article = viewModel.articles[indexPath.row]
            let detailsVM = NewsDetailsViewModel(news: article)
            detailsVC.viewModel = detailsVM
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
