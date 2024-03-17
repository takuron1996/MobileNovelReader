//
//  MainTextEndpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/11.
//

import Foundation

struct MainTextEndpoint: Endpoint {
    var urlString = "\(config.apiUrl)/api/maintext"
    var urlQueryItems: [URLQueryItem]?
    var httpBody: Codable?
    var httpMethod = HttpMethod.GET

    init(ncode: String, episode: Int) {
        urlQueryItems = [
            URLQueryItem(name: "ncode", value: ncode),
            URLQueryItem(name: "episode", value: String(episode))
        ]
    }
}
