//
//  TokenData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/02.
//

import Foundation

protocol TokenBodyProtocol: Codable{
    var grantType: String { get }
    var apiKey: String { get }
}

struct PasswordTokenBody: TokenBodyProtocol{
    var grantType = "password"
    var apiKey = config.apiKey
    var id: String
    var password: String
}

struct RefreshTokenBody: TokenBodyProtocol{
    var grantType = "refresh_token"
    var apiKey = config.apiKey
    var refreshToken: String
}

struct TokenData: Codable{
    var accessToken: String
    var refreshToken: String
}
