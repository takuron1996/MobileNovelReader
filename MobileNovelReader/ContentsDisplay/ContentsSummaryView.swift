//
//  ContentsSummaryView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

/// 小説の要約を表示し、展開/折り畳み機能を提供するビュー。
///
/// このビューは、指定された要約テキストを最初の3行で表示し、
/// 「すべて表示」ボタンをタップすることで全文を展開することができます。
/// 再度タップすると要約は折り畳まれます。
struct ContentsSummaryView: View {
    /// 表示する要約テキスト。
    var summary: String
    /// 要約テキストが展開されているかどうかを示す状態。
    @State private var isExpanded = false
    /// 要約テキストの現在の高さ。
    @State private var textHeight: CGFloat = .zero
    var body: some View {
        VStack {
            Text(summary)
                .lineLimit(isExpanded ? nil : 3)
                .animation(.easeInOut, value: isExpanded)
            HStack {
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text(isExpanded ? "折り畳む" : "すべて表示").padding(.all, 2)
                        .foregroundColor(Color.blue)
                        .cornerRadius(10)
                }
            }
        }.padding(.horizontal, 12)
    }
}

#Preview {
    ContentsSummaryView(summary: """
    八人兄弟の長男で、父が亡くなり働く母親の代わりに家事をこなして七人の弟達の世話をする毎日。
    ある日弟が車に轢かれそうになったところを助けて死んでしまった。
    次に目を覚ますと図書館で借りた小説そっくりな世界の騎士団長になってる！
    この騎士団長って確か極悪過ぎて最終的に主人公に騎士団ごと処刑されるんじゃなかったっけ！？
    俺の部下達はこれまでの俺のせいで、弟達より躾けがなってない！
    これじゃあ処刑エンドまっしぐらだよ！
    これからは俺がいい子に躾け直してやる、七人のお兄ちゃんを舐めるなよ！

    これはそんなオカン系男子の奮闘記録である。

    この作品はカクヨム様、アルファポリス様にも投稿しております。
    カクコン応募作品なのでそちらが少し先行してます。
    """)
}
