//
//  ViewState.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded
    case error(Error)
}
