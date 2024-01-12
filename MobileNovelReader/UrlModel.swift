//
//  UrlModel.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import Foundation

struct UrlModel{
    var url: URL! {
        // 後で外部APIからURLを取得
        let url = "https://ncode.syosetu.com/n0091ip/1/"
        return URL(string:url)!
    }
}
