//
//  NovelDisplayView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import SwiftUI

struct NovelDisplayView: View {
    @EnvironmentObject var fetcher: MainTextFetcher
    var ncode: String
    @State var episode: Int
    @State var mainTextData: MainText?
    
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                if fetcher.isLoading {
                    ProgressView()
                        .scaleEffect(3)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                } else if let mainTextData {
                    ScrollView{
                        Text(mainTextData.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .center)
                            .padding(.top, 80)
                        Text("第\(episode)話")
                            .font(.title)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                            .minimumScaleFactor(0.2)
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        Text(mainTextData.text)
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    NovelDisplayNavView(episode: $episode,data: mainTextData)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }else{
                    Text("本文が取得できませんでした。")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
        }.task {
            fetchData()
        }
        .onChange(of: episode){
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            mainTextData = try? await fetcher.fetchData(ncode: ncode, episode: episode)
        }
    }
    
}

#Preview {
    NovelDisplayView(ncode: "n0902ip", episode: 2)
        .environmentObject(MainTextFetcher())
}
