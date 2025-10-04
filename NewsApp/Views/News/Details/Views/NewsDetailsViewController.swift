//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    @IBOutlet var sourceNameLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    var viewModel: NewsDetailsViewModel! //will be injected
    var isLoadingImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Article Details"
        setUpView()
        loadImage()
    }
    
    private func setUpView() {
        sourceNameLabel.text = viewModel.sourceName
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        timeAgoLabel.text = viewModel.timeAgo
        authorLabel.text = viewModel.author
    }
    
    private func loadImage() {
        articleImageView.image = UIImage(resource: .newsArticlePlaceholder)
        isLoadingImage = true
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, self.isLoadingImage else { return }
                UIView.transition(with: self.articleImageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.articleImageView.image = image ?? UIImage(resource: .newsArticlePlaceholder)
                },
                                  completion: nil)
                self.isLoadingImage = false
            }
        }
    }
}
