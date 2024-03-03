//
//  ContentView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import SwiftUI

struct TmpTopPageView: View{
    @ObservedObject var appState = AppState()
    private let fetcher = Fetcher()
    
    var body: some View{
        //TODO: トップページの代用
        if appState.isLogin {
            TmpMyPageView().environmentObject(fetcher)
        }else{
            LoginDisplayView(appState: appState, fetcher: fetcher)
        }
    }
}

struct TmpMyPageView: View {
    var body: some View {
        //TODO: 出来上がっていないマイページの代用
        NavigationStack{
            VStack{
                NavigationLink(destination: ContentsView(ncode: "n9636x")) {
                    Text("n9636x")
                }
                NavigationLink(destination: ContentsView(ncode: "n5957in")) {
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
        //TODO: 出来上がっていない作者ページの代用
        Text("出来上がっていない作者ページの代用")
    }
}

#Preview {
    TmpTopPageView()
}
