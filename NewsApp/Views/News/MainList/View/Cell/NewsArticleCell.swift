//
//  NewsArticleCell.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import UIKit

class NewsArticleCell: UITableViewCell {
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var timeAgoStackView: UIStackView!
    
    private var viewModel: NewsCellViewModel?
    
    func configure(with viewModel: NewsCellViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        sourceLabel.text = viewModel.source
        timeAgoStackView.isHidden = viewModel.timeAgo == nil
        timeAgoLabel.text = viewModel.timeAgo
        newsImageView.loadImage(from: viewModel.imageURL)
    }
}
