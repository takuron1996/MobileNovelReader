//
//  Endpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import Foundation



enum HttpMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

enum ApiEndpoint{
    case mainText(ncode: String, episode: Int)
    case novelInfo(ncode: String)
    case follow(method: HttpMethod, ncode: String)
    
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

