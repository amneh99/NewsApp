//
//  Endpoint.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/2/25.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
//    func urlRequest() throws -> URLRequest {
//        var url = baseURL.appendingPathComponent(path)
//        
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//        var queryItems: [URLQueryItem] = [URLQueryItem(name: "apiKey", value: "88abaf2428e94070a3679b45c44ba569")]
//        if let parameters = parameters {
//            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
//        }
//        
//        components?.queryItems = queryItems
//        url = components?.url ?? url
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.allHTTPHeaderFields = headers
//        
//        if let parameters = parameters {
//            if method == .get {
//                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//                request.url = components?.url
//            } else {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//            }
//        }
//        
//        return request
//    }
    
//    func urlRequest() throws -> URLRequest {
//        let url = baseURL.appendingPathComponent(path).appendingPathComponent("")
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.allHTTPHeaderFields = headers
//        
//        if let parameters = parameters {
//            if method == .get {
//                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
//                request.url = components?.url
//            } else {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
//            }
//        }
//        
//        return request
//    }
    
    func urlRequest() throws -> URLRequest {
            var url = baseURL.appendingPathComponent(path)
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            // Always add apiKey
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "apiKey", value: APIConfig.apiKey)]
            
            // Add custom parameters
            if let parameters = parameters {
                queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
            }
            
            components?.queryItems = queryItems
            url = components?.url ?? url
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            if method != .get, let parameters = parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
            
            return request
        }
}

enum BaseUrl {
    static let newsBase = "https://newsapi.org/v2/"
}

struct APIConfig {
    static let apiKey = "88abaf2428e94070a3679b45c44ba569"
}
