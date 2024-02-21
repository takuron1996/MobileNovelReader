//
//  EnvironmentVariables.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import Foundation

/// アプリケーション設定を保持する構造体。
///
/// この構造体は、APIの基本URLなど、アプリケーション全体で共有される設定情報を保持します。
struct Config {
    /// APIの基本URL。
    let api_url: String
}

/// アプリケーション設定のグローバルインスタンス。
///
/// このインスタンスは、アプリケーションの起動時に`Info.plist`からAPIの基本URLを読み込み、
/// `Config`構造体のインスタンスを生成します。APIのURLが`Info.plist`に存在しない場合、
/// アプリケーションはエラーを発生させて終了します。
let config: Config = {
    guard let api_url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
        fatalError("API_URLはInfo.plistで設定する必要があります。")
    }
    return Config(api_url: api_url)
}()
