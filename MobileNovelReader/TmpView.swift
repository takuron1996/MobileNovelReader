//
//  ContentView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import SwiftUI

struct TmpMyPageView: View {
    private var fetcher = Fetcher()
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(destination: ContentsView(ncode: "n0902ip").environmentObject(fetcher)) {
                    Text("n0902ip")
                }
                NavigationLink(destination: ContentsView(ncode: "n5957in").environmentObject(fetcher)) {
                    Text("n5957in")
                }.navigationTitle("マイページ")
                    .toolbarTitleDisplayMode(.inline)
            }
        }
    }
}

struct TmpView: View {
    private var fetcher = Fetcher()
    
    var body: some View {
        //TODO: 出来上がっていないページの代用
        Text("出来上がっていないページの代用")
    }
}

#Preview {
    TmpMyPageView()
}
