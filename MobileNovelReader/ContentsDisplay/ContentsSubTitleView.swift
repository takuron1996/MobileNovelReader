//
//  NovelInfoSubTitleView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

/// 特定の小説エピソードのサブタイトルを表示し、タップ時に詳細画面を表示するビュー。
///
/// このビューは、指定されたエピソードのサブタイトルを表示し、
/// それをタップすることで該当エピソードの詳細画面に遷移します。
/// 現在読んでいるエピソードの場合は、青い円でマークされます。
struct ContentsSubTitleView: View {
    /// 小説の識別コード。
    var ncode: String
    
    /// 表示するエピソード番号。
    var episode: Int
    
    /// 現在読んでいるエピソード番号。
    var readEpisode: Int
    
    /// エピソードのサブタイトル。
    var subTitle: String
    
    /// フルスクリーンモーダルビューを表示するかどうかを制御する状態変数。
    @State private var showFullScreenModal = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // エピソードのサブタイトルを表示するボタン
            Button(action:{self.showFullScreenModal = true}) {
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .frame(minWidth:0, maxWidth: .infinity,alignment: .leading)
                    .contentShape(Rectangle())
            }
            .fullScreenCover(isPresented: $showFullScreenModal) {
                NovelDisplayView(ncode: ncode, episode: episode).environmentObject(Fetcher())
            }
            .padding(.leading, 10)
            // 現在のエピソードに青いマーカーを表示
            if episode == readEpisode{
                Circle()
                    .fill(Color.blue)
                    .frame(width: 15, height: 15)
                    .offset(x: -15, y: 0)
            }
        }
    }
}

#Preview {
    VStack{
        ContentsSubTitleView(ncode: "n0902ip", episode: 1, readEpisode:2, subTitle: "1話")
        ContentsSubTitleView(ncode: "n0902ip", episode: 2, readEpisode:2, subTitle: "2話")
        ContentsSubTitleView(ncode: "n0902ip", episode: 3, readEpisode:2, subTitle: "3話")
    }
}
