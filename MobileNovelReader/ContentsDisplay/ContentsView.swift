//
//  NovelInfoView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import SwiftUI

/// 小説の詳細情報と関連コンテンツを表示するビュー。
///
/// このビューは、特定の小説に関する情報（`NovelInfo`）を表示し、
/// 小説の各章やサブタイトルなどの追加コンテンツにアクセスするためのインターフェイスを提供します。
/// 小説のデータは非同期的にフェッチされ、データの読み込み中は進捗インジケータが表示されます。
/// データの取得に失敗した場合は、エラーメッセージが表示されます。
struct ContentsView: View {
    @EnvironmentObject var appState: AppState
    /// データフェッチ処理を管理するオブジェクト。
    @EnvironmentObject var fetcher: Fetcher
    /// 表示対象の小説の識別コード。
    let ncode: String
    /// フェッチされた小説の情報。
    @State var novelInfoData: NovelInfo?
    
    var body: some View {
        VStack {
            // データ読み込み中はプログレスビューを表示
            if fetcher.isLoading{
                ProgressView()
                    .scaleEffect(3)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }else if let novelInfoData{
                // データが存在する場合、詳細ビューとフッタービューを表示
                ContentsDetailView(ncode: ncode,novelInfo: novelInfoData)
                Divider().background(Color.black)
                ContentsFooterView(fetcher: Fetcher(delegate: appState),ncode: ncode, readEpisode: novelInfoData.readEpisode, isFollow: novelInfoData.isFollow)
                    .padding(.top, 10)
            }else{
                // データが取得できなかった場合、エラーメッセージを表示
                Text("データが取得できませんでした。")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .center)
            }
        }.task{
            // ビューが表示される際に小説のデータを非同期でフェッチ
            Task{
                guard let request = ApiEndpoint.novelInfo(ncode: ncode).request else{
                    throw FetchError.badRequest
                }
                novelInfoData = try? await fetcher.fetchData(request: request)
            }
        }
    }
}

#Preview {
    ContentsView(ncode: "n9636x").environmentObject(Fetcher(delegate: AppState()))
}
