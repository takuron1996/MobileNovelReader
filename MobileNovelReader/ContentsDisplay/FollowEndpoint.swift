//
//  FollowEndpoint.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/11.
//

import Foundation

struct FollowEndpoint: Endpoint{
    var url_string = "\(config.apiUrl)/api/follow"
    var urlQueryItems: [URLQueryItem]?
    var httpBody: Codable?
    var httpMethod: HttpMethod
    
    init(httpMethod: HttpMethod, ncode: String){
        self.httpMethod = httpMethod
        self.httpBody = FollowBody(ncode: ncode)
    }
}
