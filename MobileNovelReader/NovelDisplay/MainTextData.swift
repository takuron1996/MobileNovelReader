//
//  MainTextData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

/// 小説のメインテキストと関連情報を表すデータ構造体。
///
/// この構造体は、小説の特定のエピソードに関する詳細情報を保持します。
/// これには、エピソードのタイトル、サブタイトル、本文の配列、
/// および前後のエピソードへのナビゲーションを示すフラグが含まれます。
struct MainText: Codable {
    /// エピソードのタイトル。
    var title: String

    /// エピソードのサブタイトル。
    var subTitle: String

    /// エピソードのメインテキストを段落ごとに分割した配列。
    var mainText: [String]

    /// 前のエピソードが存在するかどうかを示すブール値。
    var prev: Bool

    /// 次のエピソードが存在するかどうかを示すブール値。
    var next: Bool
}
