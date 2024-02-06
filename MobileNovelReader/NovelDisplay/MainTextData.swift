//
//  MainTextData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

struct MainText: Codable {
    var title: String
    var sub_title: String
    var main_text: [String]
    var prev: Bool
    var next: Bool
}
