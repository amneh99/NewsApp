//
//  UIViewController.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import UIKit

extension UIViewController {
    func showLoading() {
        guard view.viewWithTag(ViewTag.spinner.rawValue) == nil else { return }
        
        let spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        spinnerView.tag = ViewTag.spinner.rawValue
        spinnerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                              .flexibleTopMargin, .flexibleBottomMargin]
        
        spinnerView.addSubview(activityIndicator)
        view.addSubview(spinnerView)
    }
    
    func hideLoading() {
        view.viewWithTag(ViewTag.spinner.rawValue)?.removeFromSuperview()
    }
    
    func showErrorAlert(message: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

private enum ViewTag: Int {
    case spinner = 999999
}
