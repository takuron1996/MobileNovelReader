//
//  Endpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import Foundation

enum ApiEndpoint{
    case mainText(ncode: String, episode: Int)
    case novelInfo(ncode: String)
    
    var url: URL? {
        let base_url = "\(config.api_url)/api"
        
        switch self {
        case .mainText(let ncode, let episode):
            var components = URLComponents(string: base_url + "/maintext")
            components?.queryItems = [
                URLQueryItem(name: "ncode", value: ncode),
                URLQueryItem(name: "episode", value: String(episode))
            ]
            return components?.url
        case .novelInfo(let ncode):
            var components = URLComponents(string: base_url + "/novelinfo")
            components?.queryItems = [
                URLQueryItem(name: "ncode", value: ncode),
            ]
            return components?.url
        }
    }
}

