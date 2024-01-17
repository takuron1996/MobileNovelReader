//
//  EnvironmentVariables.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import Foundation

struct Config {
    let api_url: String
}

let config: Config = {
    let api_url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String
    return Config(api_url: api_url)
}()
