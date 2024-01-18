//
//  NovelDisplayNavView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/01/18.
//

import SwiftUI

struct NovelDisplayNavView: View {
    @Binding var episode: Int
    var data: MainText
    @State var isEdit = true
    
    var body: some View {
        HStack {
            creatButton(condition: data.prev, title: "前の話"){
                if isEdit {
                    episode -= 1
                }
                isEdit = false
            }

            creatButton(condition: data.next, title: "次の話"){
                if isEdit{
                    episode += 1
                }
                isEdit = false
            }
        }
    }
    
    private func creatButton(condition: Bool, title: String,action: @escaping () -> Void) -> some View {
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
        NovelDisplayNavView(
            episode: .constant(1),
            data: MainText(title: "title", text: "text", prev: true, next: false)
        )
    }
}
