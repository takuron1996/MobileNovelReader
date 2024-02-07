//
//  MainTextFetcher.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import SwiftUI

//TODO 別のFetcherを作成する際に共通化について検討
class MainTextFetcher: ObservableObject {
    @Published var isLoading = false
    let urlString = "\(config.api_url)/api/maintext"
    
    enum FetchError: Error {
        case badRequest
        case badURL
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
        
        guard let url = ApiEndpoint.mainText(ncode: ncode, episode: episode).url else{
            throw FetchError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{ throw FetchError.badRequest }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(MainText.self, from: data)
    }
}
