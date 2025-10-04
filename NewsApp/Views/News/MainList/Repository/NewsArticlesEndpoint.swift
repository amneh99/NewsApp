//
//  NewsArticlesEndpoint.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/3/25.
//

import Foundation

struct NewsArticlesEndpoint: Endpoint {
    private let country: String
    
    init(country: String = "us") {
        self.country = country
    }
    
    var baseURL: URL {
        BaseUrl.newsBaseURL
    }
    
    var path: String {
        "top-headlines"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any]? {
        ["country": country]
    }
}
