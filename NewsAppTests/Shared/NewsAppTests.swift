//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Amneh Shalabyeh on 10/4/25.
//

import Testing
@testable import NewsApp

struct NewsAppTests {
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
}

extension Tag {
    @Tag static var viewModel: Self
    @Tag static var viewController: Self
    @Tag static var repository: Self
    @Tag static var integration: Self
}

func createMockArticles(count: Int) -> [Article] {
    (0..<count).map { index in
        Article(
            source: Source(id: "source-\(index)", name: "Source \(index)"),
            author: "Author \(index)",
            title: "Title \(index)",
            description: "Description \(index)",
            url: "https://example.com/\(index)",
            urlToImage: "https://example.com/image\(index).jpg",
            publishedAt: "2024-01-01T00:00:00Z",
            content: "Content \(index)"
        )
    }
}
