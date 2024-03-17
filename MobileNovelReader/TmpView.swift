//
//  TmpView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/12.
//

import SwiftUI

struct TmpTopPageView: View {
    @ObservedObject var appState = AppState()

    var body: some View {
        // TODO: トップページの代用
        if appState.isLogin {
            TmpMyPageView()
                .environmentObject(Fetcher(delegate: appState))
                .environmentObject(appState)
                .alert(isPresented: $appState.showAlert) {
                    Alert(
                        title: Text("ログインの有効期限切れ"),
                        message: Text("再度ログインしてください"),
                        dismissButton: .default(Text("OK")) {
                        appState.showAlert = false
                        appState.isLogin = false
                    })
                }
        } else {
            LoginDisplayView(appState: appState, fetcher: Fetcher(delegate: appState))
        }
    }
}

struct TmpMyPageView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        // TODO: 出来上がっていないマイページの代用
        NavigationStack {
            VStack {
                NavigationLink(destination: ContentsView(ncode: "n9636x")) {
                    Text("n9636x")
                }
                NavigationLink(destination: ContentsView(ncode: "n5957in")) {
                    Text("n5957in")
                }.navigationTitle("マイページ")
                    .toolbarTitleDisplayMode(.inline)
                // TODO: 暫定ログアウト処理
                Button(action: {
                    deleteTokenKeyChain()
                    appState.isLogin = false
                }) {
                    Text("Logout")
                        .padding(.vertical, 10)
                        .font(.headline)
                        .frame(width: 300)
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
            }
        }
    }
}

struct TmpAuthorView: View {
    var body: some View {
        // TODO: 出来上がっていない作者ページの代用
        Text("出来上がっていない作者ページの代用")
    }
}

struct TmpSignUpView: View {
    var body: some View {
        // TODO: 出来上がっていないユーザー登録ページの代用
        Text("出来上がっていないユーザー登録ページの代用")
    }
}

struct TmpForgotPasswordView: View {
    var body: some View {
        // TODO: 出来上がっていないパスワード忘れページの代用
        Text("出来上がっていないパスワード忘れページの代用")
    }
}

#Preview {
    TmpTopPageView()
}
