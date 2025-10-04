//
//  ArticleDetailsViewController.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit

class ArticleDetailsViewController: UIViewController {
    @IBOutlet var sourceNameLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    var viewModel: ArticleDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article Details"
        configureView()
    }
    
    private func configureView() {
        guard let viewModel = viewModel else {
            showEmptyState()
            return
        }
        
        sourceNameLabel.text = viewModel.sourceName
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        timeAgoLabel.text = viewModel.timeAgo
        authorLabel.text = viewModel.author
        articleImageView.loadImage(from: viewModel.imageURL)
    }
    
    private func showEmptyState() {
        sourceNameLabel.text = "No article data"
        titleLabel.text = ""
        descriptionLabel.text = ""
        authorLabel.text = ""
        timeAgoLabel.isHidden = true
    }
}
