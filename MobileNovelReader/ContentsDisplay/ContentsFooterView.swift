//
//  ContentsFotterView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/12.
//

import SwiftUI

struct ContentsFooterView: View {
    var fetcher: Fetcher
    var ncode: String
    var readEpisode: Int
    @State var isFollow: Bool
    @State private var showFullScreenModal = false
    @State private var PostFollowData: FollowData?
    @State private var DeleteFollowData: FollowData?
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
            if isFollow{
                Button(action: {
                    Task{
                        guard let request = ApiEndpoint.follow(method: .POST, ncode: ncode).request else{
                            throw FetchError.badURL
                        }
                        PostFollowData = try? await fetcher.fetchData(request: request)
                    }
                    if let PostFollowData{
                        isFollow = !PostFollowData.isSuccess
                    }
                }){
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
                }
                .padding(.leading, 10)
            }else{
                Button(action:{
                    Task{
                        guard let request = ApiEndpoint.follow(method: .DELETE, ncode: ncode).request else{
                            throw FetchError.badURL
                        }
                        DeleteFollowData = try? await fetcher.fetchData(request: request)
                    }
                    if let DeleteFollowData{
                        isFollow = DeleteFollowData.isSuccess
                    }
                }){
                    Text("フォロー中")
                        .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                        .padding(.all, 12)
                        .font(.footnote)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
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
        ContentsFooterView(fetcher: Fetcher(),ncode: "n0902ip", readEpisode: 2, isFollow: true)
        ContentsFooterView(fetcher: Fetcher(),ncode: "n0902ip", readEpisode: 0, isFollow: false)
    }
}
