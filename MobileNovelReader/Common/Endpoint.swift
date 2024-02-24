//
//  Endpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import Foundation



/// HTTPメソッドを表す列挙型。
///
/// この列挙型は、HTTPリクエストで使用される標準的なメソッドを定義します。
/// それぞれのメソッドは、異なる種類のアクションやリソースの操作を示します。
enum HttpMethod: String {
    /// HTTP GETメソッド。
    /// サーバーから情報を取得するために使用されます。
    case GET
    
    /// HTTP POSTメソッド。
    /// サーバーにデータを送信し、新しいリソースを作成するために使用されます。
    case POST
    
    /// HTTP PATCHメソッド。
    /// サーバー上の既存のリソースを部分的に更新するために使用されます。
    case PATCH
    
    /// HTTP PUTメソッド。
    /// サーバー上の既存のリソースを更新または置き換えるために使用されます。
    case PUT
    
    /// HTTP DELETEメソッド。
    /// サーバー上のリソースを削除するために使用されます。
    case DELETE
}

/// APIエンドポイントを表す列挙型。
///
/// この列挙型は、アプリケーションで使用する様々なAPIエンドポイントを定義します。
/// 各ケースは、特定のAPIリクエストとそのパラメータを表します。
enum ApiEndpoint{
    /// 特定のエピソードのメインテキストを取得するためのエンドポイント。
    /// - Parameters:
    ///   - ncode: ノベルのコード。
    ///   - episode: エピソード番号。
    case mainText(ncode: String, episode: Int)
    /// 特定のノベルの情報を取得するためのエンドポイント。
    /// - Parameter ncode: ノベルのコード。
    case novelInfo(ncode: String)
    /// ユーザーのフォロー状態を管理するためのエンドポイント。
    /// - Parameters:
    ///   - method: HTTPメソッド（POST、DELETE）。
    ///   - ncode: ノベルのコード。
    case follow(method: HttpMethod, ncode: String)
    
    /// エンドポイントに対応するURLRequestを生成します。
    /// URLRequestが生成できない場合はnilを返します。
    var request: URLRequest? {
        let base_url = "\(config.api_url)/api"
        
        switch self {
        case .mainText(let ncode, let episode):
            var components = URLComponents(string: base_url + "/maintext")
            components?.queryItems = [
                URLQueryItem(name: "ncode", value: ncode),
                URLQueryItem(name: "episode", value: String(episode))
            ]
            guard let url = components?.url else{
                return nil
            }
            return URLRequest(url: url)
        case .novelInfo(let ncode):
            var components = URLComponents(string: base_url + "/novelinfo")
            components?.queryItems = [
                URLQueryItem(name: "ncode", value: ncode),
            ]
            guard let url = components?.url else{
                return nil
            }
            return URLRequest(url: url)
        case .follow(let method, let ncode):
            var request = URLRequest(url: URL(string: base_url + "/follow")!)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.httpBody = try? JSONEncoder().encode(FollowBody(ncode: ncode))
            return request
        }
    }
}

