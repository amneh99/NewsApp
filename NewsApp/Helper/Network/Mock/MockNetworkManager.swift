//
//  MockNetworkManager.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Foundation

final class MockNetworkManager: NetworkManaging {
    var mockData: Data?
    var mockError: Error?
    
    func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
