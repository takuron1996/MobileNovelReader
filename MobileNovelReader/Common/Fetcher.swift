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
        
        let accessToken = KeyChainManager.shared.read(account: KeyChainTokenData.accessToken.rawValue)
        if let accessToken{
            return try await self.tokenFetchData(request: request, accessToken: accessToken)
        }
        let data = try await self.access(request: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    private func access(request: URLRequest) async throws -> Data{
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{ throw FetchError.badRequest }
        return data
    }
    
    private func tokenFetchData<T: Codable>(request: URLRequest, accessToken: String) async throws -> T? {
        var token_request = request
        token_request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let (data, response) = try await URLSession.shared.data(for: token_request)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            return try jsonDecoder.decode(T.self, from: data)
        }else if (response as? HTTPURLResponse)?.statusCode != 401{
            // トークンの有効期限切れ以外
            throw FetchError.badRequest
        }

        let errorData = try jsonDecoder.decode(ErrorData.self, from: data)
        guard errorData.error == "invalid_token" else {
            throw FetchError.badRequest
        }
        
        // リフレッシュトークンでのトークン取得
        let refreshToken = KeyChainManager.shared.read(account: KeyChainTokenData.refreshToken.rawValue)
        if refreshToken == nil {
            throw KeyChainError.FailureRead
        }
        let refreshTokenBody = RefreshTokenBody(refreshToken: refreshToken!)
        guard let refresh_request = ApiEndpoint.token(tokenBody: refreshTokenBody).request else{
            throw FetchError.badRequest
        }
        
        var refresh_data: Data?
        
        do{
            refresh_data = try await self.access(request: refresh_request)
        }catch{
            _ = KeyChainManager.shared.delete(account: KeyChainTokenData.accessToken.rawValue)
            _ = KeyChainManager.shared.delete(account: KeyChainTokenData.refreshToken.rawValue)
            throw error
        }
        
        let tokenData = try jsonDecoder.decode(TokenData.self, from: refresh_data!)
        try setTokenKeyChain(tokenData: tokenData)
        
        // 更新したアクセストークンで取得処理
        var retry_request = request
        retry_request.addValue("Bearer \(tokenData.accessToken)", forHTTPHeaderField: "Authorization")
        let retry_data = try await self.access(request: retry_request)
        return try jsonDecoder.decode(T.self, from: retry_data)
    }
    
}

/// ネットワークリクエスト中に発生する可能性のあるエラーを表す列挙型。
enum FetchError: Error {
    /// 不適切なリクエストまたはレスポンスエラー
    case badRequest
    /// 無効なURL
    case badURL
}
