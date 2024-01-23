//
//  ContentView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import SwiftUI

// TODO 一旦モーダルビュー用に用意
struct EpisodeModalView: View {
    var fetcher: MainTextFetcher
    var ncode: String
    var episode: Int
    @State private var showFullScreenModal = false
    
    var body: some View {
        Button("第\(episode)話") {
            self.showFullScreenModal = true
        }
        .fullScreenCover(isPresented: $showFullScreenModal) {
            NovelDisplayView(ncode: ncode, episode: episode).environmentObject(fetcher)
        }
    }
}

struct ContentView: View {
    private var fetcher = MainTextFetcher()
    
    var body: some View {
        //TODO 一旦目次の代わりに使用
        VStack {
            EpisodeModalView(fetcher: fetcher, ncode: "n0902ip", episode: 1)
            EpisodeModalView(fetcher: fetcher, ncode: "n0902ip", episode: 2)
            EpisodeModalView(fetcher: fetcher, ncode: "n0902ip", episode: 3)
        }
    }
}

#Preview {
    ContentView()
}
