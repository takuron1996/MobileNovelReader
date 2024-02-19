//
//  Fetcher.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import SwiftUI

class Fetcher: ObservableObject {
    @Published var isLoading = false
    
    func fetchData<T: Codable>(url: URL) async throws -> T? {
        Task { @MainActor in
            isLoading = true
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{ throw FetchError.badRequest }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
}

enum FetchError: Error {
    case badRequest
    case badURL
}
