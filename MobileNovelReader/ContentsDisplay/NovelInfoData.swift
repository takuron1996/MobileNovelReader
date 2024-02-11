//
//  NovelInfoData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

struct NovelInfo: Codable {
    let title: String
    let author: String
    let episodeCount: Int
    let releaseDate: String
    let tag: [String]
    let summary: String
    let category: String
    let subCategory: String
    let updatedAt: String
    let readEpisode: Int
    let chapters: [Chapter]
}

struct Chapter: Codable, Hashable {
    let chapterTitle: String
    let subTitles: [String]
}
