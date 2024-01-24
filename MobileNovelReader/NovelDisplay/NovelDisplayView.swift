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
    @Environment(\.presentationMode) var presentationMode
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
                    Text(mainTextData.sub_title)
                        .font(.title)
                        .frame(minWidth:0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                        .minimumScaleFactor(0.2)
                        .padding(.bottom, 20)
                    Text(mainTextData.main_text.joined(separator: "\n"))
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
    
    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    isTapped.toggle()
                }
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
