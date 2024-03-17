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

    weak var delegate: FetcherDelegate?

    init(delegate: FetcherDelegate) {
        self.delegate = delegate
    }

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
        if let accessToken {
            return try await tokenFetchData(request: request, accessToken: accessToken)
        }
        let data = try await access(request: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(T.self, from: data)
    }

    private func access(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
        return data
    }

    private func tokenFetchData<T: Codable>(request: URLRequest, accessToken: String) async throws -> T? {
        var tokenRequest = request
        tokenRequest.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let (data, response) = try await URLSession.shared.data(for: tokenRequest)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            return try jsonDecoder.decode(T.self, from: data)
        } else if (response as? HTTPURLResponse)?.statusCode != 401 {
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
            delegate?.dataFetchFailed()
            throw KeyChainError.failureRead
        }
        let refreshTokenBody = RefreshTokenBody(refreshToken: refreshToken!)
        guard let refreshRequest = ApiRequest(endpoint: TokenEndpoint(tokenBody: refreshTokenBody)).request else {
            delegate?.dataFetchFailed()
            throw FetchError.badRequest
        }

        var refreshData: Data?

        do {
            refreshData = try await access(request: refreshRequest)
        } catch {
            deleteTokenKeyChain()
            delegate?.dataFetchFailed()
            throw error
        }

        let tokenData = try jsonDecoder.decode(TokenData.self, from: refreshData!)
        try setTokenKeyChain(tokenData: tokenData)

        // 更新したアクセストークンで取得処理
        var retryRequest = request
        retryRequest.addValue("Bearer \(tokenData.accessToken)", forHTTPHeaderField: "Authorization")
        let retryData = try await access(request: retryRequest)
        return try jsonDecoder.decode(T.self, from: retryData)
    }
}

/// ネットワークリクエスト中に発生する可能性のあるエラーを表す列挙型。
enum FetchError: Error {
    /// 不適切なリクエストまたはレスポンスエラー
    case badRequest
    /// 無効なURL
    case badURL
}

protocol FetcherDelegate: AnyObject {
    func dataFetchedSuccessfully(data: Data)
    func dataFetchFailed()
}
