//
//  NovelDisplayView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/17.
//

import SwiftUI

/// 小説の特定エピソードの表示ビュー。
///
/// このビューは、選択された小説の特定のエピソードを表示します。
/// ビューには、エピソードのタイトル、サブタイトル、および本文が含まれます。
/// ユーザーはタップジェスチャーで追加のナビゲーションオプションを表示/非表示にできます。
struct NovelDisplayView: View {
    
    /// データフェッチを管理する環境オブジェクト。
    @EnvironmentObject var fetcher: Fetcher
    
    /// 小説の識別コード。
    var ncode: String
    
    /// 表示するエピソードの番号。
    @State var episode: Int
    
    /// フェッチされた小説のエピソードデータ。
    @State var mainTextData: MainText?
    
    /// プレゼンテーションモードの環境変数。
    @Environment(\.presentationMode) var presentationMode
    
    /// タップジェスチャーの状態。
    @State private var isTapped = true
    
    var body: some View {
        VStack{
            Spacer()
            if fetcher.isLoading {
                ProgressView()
                    .scaleEffect(3)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            } else if let mainTextData {
                if isTapped{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .padding()
                            .foregroundColor(.black)
                    }
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 20, alignment: .trailing)
                    Divider().background(Color.black)
                }
                ScrollView{
                    Text(mainTextData.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .center)
                        .padding(.top, 40)
                    Text("第\(episode)話")
                        .font(.title)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 30, alignment: .center)
                        .minimumScaleFactor(0.2)
                        .padding(.top, 40)
                    Text(mainTextData.subTitle)
                        .font(.title)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                        .minimumScaleFactor(0.2)
                        .padding(.bottom, 20)
                    Text(mainTextData.mainText.joined(separator: "\n"))
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if isTapped{
                    NovelDisplayMenuView(episode: $episode,data: mainTextData)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            }else{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .padding()
                        .foregroundColor(.black)
                }
                .frame(minWidth:0, maxWidth: .infinity, alignment: .trailing)
                Divider().background(Color.black)
                Text("本文が取得できませんでした。")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30)
        .task {
            fetchData()
        }
        .onChange(of: episode){
            fetchData()
            isTapped = true
        }
        .gesture(tapGesture)
    }
    
    /// タップジェスチャーの定義。
    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    isTapped.toggle()
                }
            }
    }
    
    /// 指定されたエピソードのデータをフェッチするメソッド。
    private func fetchData() {
        Task {
            guard let request = ApiEndpoint.mainText(ncode: ncode, episode: episode).request else{
                throw FetchError.badURL
            }
            mainTextData = try? await fetcher.fetchData(request: request)
        }
    }
    
}

#Preview {
    NovelDisplayView(ncode: "n0902ip", episode: 2)
        .environmentObject(Fetcher())
}
