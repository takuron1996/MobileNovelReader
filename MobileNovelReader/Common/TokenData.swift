//
//  TokenData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/02.
//

import Foundation

protocol TokenBodyProtocol: Codable{
    var grantType: String { get }
}

struct PasswordTokenBody: TokenBodyProtocol{
    var grantType = "password"
    var id: String
    var password: String
}

struct RefreshTokenBody: TokenBodyProtocol{
    var grantType = "refresh_token"
    var refreshToken: String
}

struct TokenData: Codable{
    var accessToken: String
    var refreshToken: String
}
