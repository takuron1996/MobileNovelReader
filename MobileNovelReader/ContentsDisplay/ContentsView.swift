//
//  NovelInfoView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/07.
//

import SwiftUI

struct ContentsView: View {
    @EnvironmentObject var fetcher: Fetcher
    let ncode: String
    @State var novelInfoData: NovelInfo?
    
    var body: some View {
        VStack {
            if fetcher.isLoading{
                ProgressView()
                    .scaleEffect(3)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }else if let novelInfoData{
                ContentsDetailView(ncode: ncode,novelInfo: novelInfoData)
                Divider().background(Color.black)
                ContentsFooterView(fetcher: Fetcher(),ncode: ncode, readEpisode: novelInfoData.readEpisode, isFollow: novelInfoData.isFollow)
                    .padding(.top, 10)
            }else{
                Text("データが取得できませんでした。")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .center)
            }
        }.task{
            Task{
                guard let request = ApiEndpoint.novelInfo(ncode: ncode).request else{
                    throw FetchError.badURL
                }
                novelInfoData = try? await fetcher.fetchData(request: request)
            }
        }
    }
}

#Preview {
    ContentsView(ncode: "n0902ip").environmentObject(Fetcher())
}
