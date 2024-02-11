//
//  NovelInfoSubTitleView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

struct ContentsSubTitleView: View {
    var ncode: String
    var episode: Int
    var readEpisode: Int
    var subTitle: String
    @State private var showFullScreenModal = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
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
