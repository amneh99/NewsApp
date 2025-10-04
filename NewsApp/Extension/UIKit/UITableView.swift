//
//  UITableView.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import UIKit

extension UITableView {
    func setBackground(state: TableViewState) {
        backgroundView = state == .empty ? createEmptyStateView(message: state.message) : nil
    }
    
    private func createEmptyStateView(message: String) -> UIView {
        let label = UILabel()
        label.text = message
        label.textColor = .bodyText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }
}

enum TableViewState {
    case normal
    case empty
    
    var message: String {
           switch self {
           case .normal: return ""
           case .empty: return "No results available"
           }
       }
}
