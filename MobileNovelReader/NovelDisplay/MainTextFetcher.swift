//
//  MainTextFetcher.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import SwiftUI

class MainTextFetcher: ObservableObject {
    @Published var isLoading = false
    let urlString = "\(config.api_url)/api/maintext"
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchData(ncode: String, episode: Int) async throws -> MainText? {
        Task { @MainActor in
            isLoading = true
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "ncode", value: ncode),
            URLQueryItem(name: "episode", value: String(episode))
        ]
        
        guard let url = components?.url else{
            print("不正なURL")
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{ throw FetchError.badRequest }
        
        return try JSONDecoder().decode(MainText.self, from: data)
    }
}
