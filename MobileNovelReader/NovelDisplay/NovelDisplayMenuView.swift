//
//  NovelDisplayNavView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/18.
//

import SwiftUI

/// 小説のエピソードナビゲーション用のメニュービュー。
///
/// このビューは、指定されたエピソードの「前の話」と「次の話」へのナビゲーションボタンを提供します。
/// 各ボタンは、エピソードが存在する場合にのみ表示され、タップすることでエピソード番号を更新します。
struct NovelDisplayMenuView: View {
    /// 現在表示しているエピソード番号。
    @Binding var episode: Int
    
    /// 表示しているエピソードのデータ。
    var data: MainText
    
    /// ボタンの連打による誤操作を防ぐためのフラグ。
    @State var isEpisodeEdit = true
    
    var body: some View {
        HStack {
            // 「前の話」ボタンの生成
            createButton(condition: data.prev, title: "前の話"){
                if isEpisodeEdit {
                    episode -= 1
                }
                isEpisodeEdit = false
            }
            
            // 「次の話」ボタンの生成
            createButton(condition: data.next, title: "次の話"){
                if isEpisodeEdit{
                    episode += 1
                }
                isEpisodeEdit = false
            }
        }
    }
    
    /// 特定の条件に基づいてボタンを生成するヘルパーメソッド。
    ///
    /// - Parameters:
    ///   - condition: ボタンが有効であるかどうかを示すブール値。
    ///   - title: ボタンに表示するテキスト。
    ///   - action: ボタンがタップされたときに実行されるアクション。
    /// - Returns: 生成されたボタン。
    private func createButton(condition: Bool, title: String,action: @escaping () -> Void) -> some View {
        Group {
            if condition {
                Button(action: action){
                    Text(title)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            } else {
                Image(systemName: "xmark")
                    .padding()
                    .frame(minWidth: 0,maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    NavigationStack {
        NovelDisplayMenuView(
            episode: .constant(1),
            data: MainText(title: "title", subTitle: "text", mainText: ["a", "", "b"], prev: true, next: false)
        )
    }
}
