//
//  TokenEndpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/11.
//

import Foundation

struct TokenEndpoint: Endpoint {
    var urlString = "\(config.apiUrl)/api/token"
    var urlQueryItems: [URLQueryItem]?
    var httpBody: Codable?
    var httpMethod: HttpMethod = .POST

    init(tokenBody: TokenBodyProtocol) {
        httpBody = tokenBody
    }
}
