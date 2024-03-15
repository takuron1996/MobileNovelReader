//
//  Endpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import Foundation

protocol Endpoint {
    var urlString: String { get }
    var urlQueryItems: [URLQueryItem]? { get }
    var httpBody: Codable? { get }
    var httpMethod: HttpMethod { get }
}

struct ApiRequest {
    var endpoint: Endpoint
    var request: URLRequest? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        var components = URLComponents(string: endpoint.urlString)
        if let urlQueryItems = endpoint.urlQueryItems {
            components?.queryItems = urlQueryItems
        }
        guard let url = components?.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let signature = createSignature(method: endpoint.httpMethod, url: url) else {
            return nil
        }
        request.addValue(signature, forHTTPHeaderField: "Signature")
        request.httpMethod = endpoint.httpMethod.rawValue
        if let httpBody = endpoint.httpBody {
            request.httpBody = try? jsonEncoder.encode(httpBody)
        }
        return request
    }
}

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
