//
//  ContentsFooterView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/12.
//

import SwiftUI

/// 小説のフッタービューで、読み始めるボタンやフォローボタンを表示します。
///
/// このビューは、ユーザーが小説の特定のエピソードから読み始めることができるボタン、
/// および小説をフォロー/フォロー解除するためのボタンを提供します。
struct ContentsFooterView: View {
    @EnvironmentObject var appState: AppState
    /// データフェッチ処理を管理するオブジェクト。
    var fetcher: Fetcher
    /// 小説の識別コード。
    var ncode: String
    /// 現在読んでいるエピソード番号。
    var readEpisode: Int
    /// 小説がフォローされているかどうかを示す状態。
    @State var isFollow: Bool
    /// モーダルビューを表示するかどうかを制御する状態。
    @State private var showFullScreenModal = false
    /// POSTフォローデータの状態。
    @State private var postFollowData: FollowData?
    /// DELETEフォローデータの状態。
    @State private var deleteFollowData: FollowData?
    /// プレゼンテーションモードの環境変数。
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack {
            // 「戻る」ボタンの表示
            if presentationMode.wrappedValue.isPresented {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }.padding(.leading, -10)
            }
            // 「読み始める」または「続きから読む」ボタン
            if readEpisode == 0 {
                createButton(text: "1話目から読む", episode: 1)
            } else {
                createButton(text: "続きから読む", episode: readEpisode)
            }
            // 「フォローする」または「フォロー中」ボタン
            if isFollow {
                Button(action: {
                    Task {
                        guard let request = ApiRequest(
                            endpoint: FollowEndpoint(
                                httpMethod: .DELETE,
                                ncode: ncode))
                            .request else {
                            throw FetchError.badRequest
                        }
                        do {
                            deleteFollowData = try await fetcher.fetchData(request: request)
                        } catch {
                            print("フォロー解除のFetchに失敗しました: \(error.localizedDescription)")
                        }
                        if let deleteFollowData {
                            isFollow = !deleteFollowData.isSuccess
                        }
                    }
                }) {
                    Text("フォロー中")
                        .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                        .padding(.all, 12)
                        .font(.footnote)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
                .padding(.leading, 10)
            } else {
                Button(action: {
                    Task {
                        guard let request = ApiRequest(
                            endpoint: FollowEndpoint(
                                httpMethod: .POST,
                                ncode: ncode))
                            .request else {
                            throw FetchError.badRequest
                        }
                        do {
                            postFollowData = try await fetcher.fetchData(request: request)
                        } catch {
                            print("フォローのFetchに失敗しました: \(error.localizedDescription)")
                        }
                        if let postFollowData {
                            isFollow = postFollowData.isSuccess
                        }
                    }

                }) {
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
            }
        }
    }

    /// 指定されたテキストとエピソード番号でボタンを生成します。
    ///
    /// - Parameters:
    ///   - text: ボタンに表示するテキスト。
    ///   - episode: 関連するエピソード番号。
    /// - Returns: 指定された設定で生成されたボタン。
    private func createButton(text: String, episode: Int) -> some View {
        return Button(action: { self.showFullScreenModal = true }) {
            Text(text)
                .frame(minWidth: 0, maxWidth: 100, alignment: .center)
                .contentShape(Rectangle())
                .padding(.all, 12)
                .font(.footnote)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(30)
        }
        .fullScreenCover(isPresented: $showFullScreenModal) {
            NovelDisplayView(ncode: ncode, episode: episode).environmentObject(Fetcher(delegate: appState))
        }
        .padding(.leading, 10)
    }
}

#Preview {
    VStack {
        ContentsFooterView(fetcher: Fetcher(delegate: AppState()), ncode: "n9636x", readEpisode: 2, isFollow: true)
        ContentsFooterView(fetcher: Fetcher(delegate: AppState()), ncode: "n9636x", readEpisode: 0, isFollow: false)
    }
}
