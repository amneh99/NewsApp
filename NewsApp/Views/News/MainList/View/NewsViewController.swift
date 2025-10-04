//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit
//import Combine

class NewsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let viewModel = NewsViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        Task {
            await getTopHeadlines()
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        Task {
            await getTopHeadlines()
        }
    }
    
    func getTopHeadlines() async {
        if !refreshControl.isRefreshing { showLoading() }
        await viewModel.getTopHeadlines()
        if !refreshControl.isRefreshing { hideLoading() }
        
        if let errorMsg = viewModel.error?.errorDescription {
            showErrorAlert(message: errorMsg)
        } else {
            tableView.reloadData()
        }
        
        tableView.setBackground(state: viewModel.articles.isEmpty ? .empty : .normal)
        
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate extension
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        
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
