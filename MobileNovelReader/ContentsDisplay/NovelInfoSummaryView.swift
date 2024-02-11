//
//  NovelInfoSummaryView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//


import SwiftUI

struct NovelInfoSummaryView: View {
    var summary: String
    @State private var isExpanded = false
    @State private var textHeight: CGFloat = .zero
    var body: some View {
        VStack{
            Text(summary)
                .lineLimit(isExpanded ? nil : 3)
                .animation(.easeInOut, value: isExpanded)
            HStack {
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Text(isExpanded ? "折り畳む" : "すべて表示").padding(.all, 8)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
            }
        }.padding(.horizontal, 12)
    }
}

#Preview {
        NovelInfoSummaryView(summary:"八人兄弟の長男で、父が亡くなり働く母親の代わりに家事をこなして七人の弟達の世話をする毎日。\nある日弟が車に轢かれそうになったところを助けて死んでしまった。\n次に目を覚ますと図書館で借りた小説そっくりな世界の騎士団長になってる！\nこの騎士団長って確か極悪過ぎて最終的に主人公に騎士団ごと処刑されるんじゃなかったっけ！？\n俺の部下達はこれまでの俺のせいで、弟達より躾けがなってない！\nこれじゃあ処刑エンドまっしぐらだよ！\nこれからは俺がいい子に躾け直してやる、七人のお兄ちゃんを舐めるなよ！\n\nこれはそんなオカン系男子の奮闘記録である。\n\n\nこの作品はカクヨム様、アルファポリス様にも投稿しております。\nカクコン応募作品なのでそちらが少し先行してます。")
}
