//
//  UIImageView.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String?, placeholder: UIImage? = UIImage(resource: .newsArticlePlaceholder)) {
        image = placeholder
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let downloadedImage = UIImage(data: data) {
                    await MainActor.run {
                        UIView.transition(with: self,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: { self.image = downloadedImage })
                    }
                }
            } catch { }
        }
    }
}
