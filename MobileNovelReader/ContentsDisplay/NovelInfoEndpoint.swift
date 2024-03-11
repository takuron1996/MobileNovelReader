//
//  NovelInfoEndpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/11.
//

import Foundation

struct NovelInfoEndpoint: Endpoint{
    var url_string = "\(config.apiUrl)/api/novelinfo"
    var urlQueryItems: [URLQueryItem]?
    var httpBody: Codable?
    var httpMethod = HttpMethod.GET
    
    init(ncode: String){
        urlQueryItems = [
            URLQueryItem(name: "ncode", value: ncode),
        ]
    }
}
