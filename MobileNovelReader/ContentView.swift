//
//  ContentView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import SwiftUI

struct ContentView: View {
    private var fetcher = MainTextFetcher()
    
    var body: some View {
        //TODO 一旦目次の代わりに使用
        NavigationStack{
            NavigationLink(destination: NovelDisplayView(ncode: "n0902ip", episode: 1).environmentObject(fetcher)) {
                Text("第1話")
            }
            NavigationLink(destination: NovelDisplayView(ncode: "n0902ip", episode: 2).environmentObject(fetcher)) {
                Text("第2話")
            }
            NavigationLink(destination: NovelDisplayView(ncode: "n0902ip", episode: 3).environmentObject(fetcher)) {
                Text("第3話")
            }
        }
    }
}

#Preview {
    ContentView()
}
