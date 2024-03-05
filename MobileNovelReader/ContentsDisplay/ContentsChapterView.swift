//
//  NovelInfoChapterView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

/// 小説の各章とサブタイトルを表示するビュー。
///
/// このビューは、指定された小説の各章とそれに関連するサブタイトルをリスト形式で表示します。
/// 各サブタイトルはタップ可能で、関連するエピソードの詳細ビューに遷移します。
struct ContentsChapterView: View {
    @EnvironmentObject var appState: AppState
    /// 小説の識別コード。
    var ncode: String
    /// 現在読んでいるエピソード番号。
    var readEpisode: Int
    /// 表示する小説の章の配列。
    var chapters: [Chapter]
    /// 各章のサブタイトルに対応するエピソード番号の配列。
    var episodeNumbers: [[Int]]
    
    var body: some View {
        VStack{
            ForEach(Array(zip(chapters, episodeNumbers)), id: \.1) { (chapter, episodes) in
                if !chapter.chapterTitle.isEmpty{
                    Text(chapter.chapterTitle)
                        .font(.headline)
                        .frame(minWidth:0, maxWidth: .infinity,alignment: .leading)
                        .padding(.leading, 10)
                    Divider().background(Color.black)
                }
                ForEach(Array(zip(chapter.subTitles, episodes)), id: \.1){ (subTitle, episode) in
                    ContentsSubTitleView(ncode: ncode, episode: episode,readEpisode:readEpisode, subTitle:subTitle).environmentObject(Fetcher(delegate: appState))
                    Divider().background(Color.black)
                }
            }
        }
    }
}

#Preview {
    ContentsChapterView(ncode: "n9636x", readEpisode: 2, chapters: ([
        Chapter(chapterTitle: "序章", subTitles: ["1話", "2話", "3話"]),
        Chapter(chapterTitle: "第一章", subTitles: ["1話", "2話"])
    ]), episodeNumbers: [[1, 2, 3], [4, 5]])
}
