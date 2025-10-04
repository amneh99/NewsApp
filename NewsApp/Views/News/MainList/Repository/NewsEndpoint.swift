//
//  NewsEndpoint.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import Foundation

enum NewsEndpoint: Endpoint {
    case topHeadlines(country: String)
    case everything(query: String)
    
    var baseURL: URL {
        URL(string: BaseUrl.newsBase)!
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "top-headlines"
        case .everything:
            return "everything"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .topHeadlines(let country):
            return ["country": country]
        case .everything(let query):
            return ["q": query]
        }
    }
}
