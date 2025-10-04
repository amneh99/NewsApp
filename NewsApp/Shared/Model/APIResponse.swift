//
//  APIResponse.swift
//  NewsApp
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [T]? //normally would be data
}
