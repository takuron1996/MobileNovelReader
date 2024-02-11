//
//  NovelInfoSubTitleView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

struct NovelInfoSubTitleView: View {
    var ncode: String
    var episode: Int
    var subTitle: String
    @State private var showFullScreenModal = false
    
    var body: some View {
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
    }
}

#Preview {
    VStack{
        NovelInfoSubTitleView(ncode: "n0902ip", episode: 1, subTitle: "1話")
        NovelInfoSubTitleView(ncode: "n0902ip", episode: 2, subTitle: "2話")
        NovelInfoSubTitleView(ncode: "n0902ip", episode: 3, subTitle: "3話")
    }
}
