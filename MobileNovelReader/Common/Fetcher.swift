//
//  Fetcher.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import SwiftUI

/// ネットワークリクエストを管理するクラス。
///  
/// このクラスは、URLリクエストを実行し、結果をデコードする機能を提供します。
/// リクエスト中のローディング状態も管理します。
class Fetcher: ObservableObject {
    /// リクエスト中であるかどうかを示すフラグ。
    @Published var isLoading = false
    
    /// 指定されたURLリクエストを実行し、結果をデコードします。
    ///
    /// - Parameters:
    ///   - request: 実行する`URLRequest`オブジェクト。
    /// - Returns: デコードされたレスポンスデータ。リクエストが失敗した場合は`nil`。
    /// - Throws: `FetchError`リクエストが失敗した場合。
    func fetchData<T: Codable>(request: URLRequest) async throws -> T? {
        Task { @MainActor in
            isLoading = true
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{ throw FetchError.badRequest }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
}

/// ネットワークリクエスト中に発生する可能性のあるエラーを表す列挙型。
enum FetchError: Error {
    /// 不適切なリクエストまたはレスポンスエラー
    case badRequest
    /// 無効なURL
    case badURL
}
