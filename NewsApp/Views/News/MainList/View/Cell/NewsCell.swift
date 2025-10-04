//
//  NewsCell.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var timeAgoStackView: UIStackView!
    
    private var viewModel: NewsCellViewModel?
    private var isLoadingImage = false

    func configure(with viewModel: NewsCellViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        sourceLabel.text = viewModel.source
        timeAgoStackView.isHidden = viewModel.timeAgo == nil
        timeAgoLabel.text = viewModel.timeAgo
        
        loadImage()
    }
    
    private func loadImage() {
        // Show placeholder
        newsImageView.image = UIImage(resource: .newsArticlePlaceholder)
        
        isLoadingImage = true
        
        viewModel?.loadImage { [weak self] image in
            DispatchQueue.main.async {
                // Ensure we're still loading and this cell hasn't been reused
                guard let self = self, self.isLoadingImage else { return }
                
                UIView.transition(with: self.newsImageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.newsImageView.image = image ?? UIImage(resource: .newsArticlePlaceholder)
                },
                                  completion: nil)
                
                self.isLoadingImage = false
            }
        }
    }
}
