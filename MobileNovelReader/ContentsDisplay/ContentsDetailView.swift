//
//  NovelInfoDetailView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/09.
//

import SwiftUI

/// 小説の詳細情報を表示するビュー。
///
/// このビューは、指定された小説のタイトル、作者、カテゴリ、サブカテゴリ、
/// タグ、要約、エピソード数、公開日、最終更新日を表示します。
/// また、各章のサブタイトルと対応するエピソード番号も表示されます。
struct ContentsDetailView: View {
    /// 小説の識別コード。
    var ncode: String
    /// 表示する小説の情報。
    var novelInfo: NovelInfo
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView{
                    Text(novelInfo.title)
                        .padding(.top)
                        .font(.title)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .leading)
                        .padding(.leading)
                    //TODO: 作者ページを後で作成
                    NavigationLink(destination: TmpAuthorView()) {
                        Text(novelInfo.author)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .leading)
                            .padding(.leading)
                    }.padding(.bottom)
                    Divider().background(Color.black)
                    Text("\(novelInfo.category) / \(novelInfo.subCategory)")
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top)
                    ContentsTagView(tags: novelInfo.tag, containerWidth: geometry.size.width).padding(.bottom)
                    Divider().background(Color.black)
                    ContentsSummaryView(summary: novelInfo.summary).padding(.vertical, 3)
                    Divider().background(Color.black)
                    HStack{
                        Spacer()
                        createText(text: "\(String(novelInfo.episodeCount))話")
                        createText(text: "\(releaseDate) 公開")
                        createText(text: "\(updateAt) 更新")
                    }.padding(.all,5)
                    Divider().background(Color.black)
                    let episodeNumbers = generateEpisodeNumbers(for: novelInfo.chapters)
                    ContentsChapterView(ncode: ncode, readEpisode: novelInfo.readEpisode,chapters: novelInfo.chapters, episodeNumbers: episodeNumbers)
                    Spacer()
                }
            }
            
        }
    }
    
    /// 小説の公開日をフォーマットするプロパティ
    var releaseDate: String{
        return novelInfo.releaseDate.replacingOccurrences(of: "-", with: "/")
    }
    
    /// 小説の公開日をフォーマットするプロパティ
    var updateAt:String {
        return novelInfo.updatedAt.replacingOccurrences(of: "-", with: "/")
    }
    
    /// 指定したテキストをフォーマットして表示するヘルパーメソッド
    func createText(text: String) -> Text {
        return Text(text)
            .foregroundColor(Color.gray)
            .font(.system(size: 14))
    }
    
    /// 各章のエピソード番号を生成するヘルパーメソッド
    func generateEpisodeNumbers(for chapters: [Chapter]) -> [[Int]] {
        var episodeNumbers: [[Int]] = []
        var currentEpisode = 1

        for chapter in chapters {
            let chapterEpisodeNumbers = chapter.subTitles.map { _ in
                let episode = currentEpisode
                currentEpisode += 1
                return episode
            }
            episodeNumbers.append(chapterEpisodeNumbers)
        }

        return episodeNumbers
    }
    
}

extension NovelInfo {
    static var sampleData: NovelInfo {
        return NovelInfo(
            title: "サンプルタイトル",
            author: "サンプル作者",
            episodeCount: 10,
            releaseDate: "2023-01-15",
            tag: ["タグ１", "タグ２", "タグ３","タグ4", "タグ5", "タグ6","タグ7", "タグ8", "タグ9"],
            summary: "八人兄弟の長男で、父が亡くなり働く母親の代わりに家事をこなして七人の弟達の世話をする毎日。\nある日弟が車に轢かれそうになったところを助けて死んでしまった。\n次に目を覚ますと図書館で借りた小説そっくりな世界の騎士団長になってる！\nこの騎士団長って確か極悪過ぎて最終的に主人公に騎士団ごと処刑されるんじゃなかったっけ！？\n俺の部下達はこれまでの俺のせいで、弟達より躾けがなってない！\nこれじゃあ処刑エンドまっしぐらだよ！\nこれからは俺がいい子に躾け直してやる、七人のお兄ちゃんを舐めるなよ！\n\nこれはそんなオカン系男子の奮闘記録である。\n\n\nこの作品はカクヨム様、アルファポリス様にも投稿しております。\nカクコン応募作品なのでそちらが少し先行してます。",
            category: "大ジャンル",
            subCategory: "ジャンル",
            updatedAt: "2023-04-10",
            readEpisode: 2,
            chapters: [
                Chapter(chapterTitle: "序章", subTitles: ["１話", "２話"]),
                Chapter(chapterTitle: "第一章", subTitles: ["３話", "４話"])
            ],
            isFollow: true
        )
    }
}

#Preview {
    ContentsDetailView(ncode: "n9636x",novelInfo: NovelInfo.sampleData).environmentObject(Fetcher(delegate: AppState())).environmentObject(AppState())
}
