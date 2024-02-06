//
//  NovelDisplayNavView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/18.
//

import SwiftUI

struct NovelDisplayMenuView: View {
    @Binding var episode: Int
    var data: MainText
    // ボタン連打対策
    @State var isEpisodeEdit = true
    
    var body: some View {
        HStack {
            createButton(condition: data.prev, title: "前の話"){
                if isEpisodeEdit {
                    episode -= 1
                }
                isEpisodeEdit = false
            }

            createButton(condition: data.next, title: "次の話"){
                if isEpisodeEdit{
                    episode += 1
                }
                isEpisodeEdit = false
            }
        }
    }
    
    private func createButton(condition: Bool, title: String,action: @escaping () -> Void) -> some View {
        Group {
            if condition {
                Button(title, action: action)
                    .padding()
                    .frame(minWidth: 0,maxWidth: .infinity)
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
