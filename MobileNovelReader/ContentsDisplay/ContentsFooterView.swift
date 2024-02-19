//
//  ContentsFotterView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/12.
//

import SwiftUI

struct ContentsFooterView: View {
    var ncode: String
    var readEpisode: Int
    var isFollow: Bool
    @State private var showFullScreenModal = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack{
            if presentationMode.wrappedValue.isPresented {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                }.padding(.leading, -10)
            }
            if readEpisode == 0{
                createButton(text: "1話目から読む", episode: 1)
            }else{
                createButton(text: "続きから読む", episode: readEpisode)
            }
            //TODO: フォロー機能は未作成
            if(isFollow){
                Text("フォロー")
                    .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                    .padding(.all, 12)
                    .font(.footnote)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.leading, 10)
            }else{
                Text("フォロー中")
                    .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                    .padding(.all, 12)
                    .font(.footnote)
                    .background(Color.gray)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                    .padding(.leading, 10)
            }
            
        }
    }
    
    func createButton(text: String, episode:Int) -> some View{
        return Button(action:{self.showFullScreenModal = true}) {
            Text(text)
                .frame(minWidth:0, maxWidth: 100,alignment: .center)
                .contentShape(Rectangle())
                .padding(.all, 12)
                .font(.footnote)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(30)
        }
        .fullScreenCover(isPresented: $showFullScreenModal) {
            NovelDisplayView(ncode: ncode, episode: episode).environmentObject(Fetcher())
        }
        .padding(.leading, 10)
    }
}

#Preview {
    VStack{
        ContentsFooterView(ncode: "n0902ip", readEpisode: 2, isFollow: true)
        ContentsFooterView(ncode: "n0902ip", readEpisode: 0, isFollow: false)
    }
}
