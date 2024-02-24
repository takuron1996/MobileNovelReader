//
//  NovelInfoData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

/// 小説の情報を表す構造体。
///
/// この構造体は、小説のタイトル、作者、エピソード数などの情報を保持します。
struct NovelInfo: Codable {
    /// 小説のタイトル。
    let title: String
    
    /// 小説の作者。
    let author: String
    
    /// 小説のエピソード数。
    let episodeCount: Int
    
    /// 小説の公開日。
    let releaseDate: String
    
    /// 小説に関連するタグのリスト。
    let tag: [String]
    
    /// 小説の概要。
    let summary: String
    
    /// 小説のカテゴリ。
    let category: String
    
    /// 小説のサブカテゴリ。
    let subCategory: String
    
    /// 小説の最終更新日。
    let updatedAt: String
    
    /// ユーザーが読んだ最後のエピソード番号。
    let readEpisode: Int
    
    /// 小説の章情報のリスト。
    let chapters: [Chapter]
    
    /// ユーザーが小説をフォローしているかどうか。
    let isFollow: Bool
}

/// 小説の章を表す構造体。
///
/// この構造体は、章のタイトルとサブタイトルのリストを保持します。
struct Chapter: Codable, Hashable {
    /// 章のタイトル。
    let chapterTitle: String
    
    /// 章内のサブタイトルのリスト。
    let subTitles: [String]
}
