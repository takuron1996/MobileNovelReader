//
//  NovelInfoChapterView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

struct ContentsChapterView: View {
    var ncode: String
    var readEpisode: Int
    var chapters: [Chapter]
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
                    ContentsSubTitleView(ncode: ncode, episode: episode,readEpisode:readEpisode, subTitle:subTitle).environmentObject(Fetcher())
                    Divider().background(Color.black)
                }
            }
        }
    }
}

#Preview {
    ContentsChapterView(ncode: "n0902ip", readEpisode: 2, chapters: ([
        Chapter(chapterTitle: "序章", subTitles: ["1話", "2話", "3話"]),
        Chapter(chapterTitle: "第一章", subTitles: ["1話", "2話"])
    ]), episodeNumbers: [[1, 2, 3], [4, 5]])
}
