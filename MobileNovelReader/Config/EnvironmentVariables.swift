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
    let apiUrl: String
    
    let apiKey: String
}

//TODO: コメント修正（apiKey）
/// アプリケーション設定のグローバルインスタンス。
///
/// このインスタンスはアプリケーションの起動時に`Info.plist`からAPIの基本URLを読み込みます。
/// APIのURLはアプリケーションの基本的な動作に不可欠であるため、このURLが`Info.plist`に存在しない場合、
/// アプリケーションは`fatalError`を発生させて直ちに終了します。これにより、誤ってAPIのURLが設定されていない
/// 状態でアプリケーションが動作することを防ぎます。この挙動はクリティカルな依存関係を持つアプリケーション設定に
/// 必要なエラーハンドリングとして設計されています。
let config: Config = {
    guard let apiUrl = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
        fatalError("API_URLはInfo.plistで設定する必要があります。")
    }
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
        fatalError("API_KeyはInfo.plistで設定する必要があります。")
    }
    return Config(apiUrl: apiUrl, apiKey: apiKey)
}()
