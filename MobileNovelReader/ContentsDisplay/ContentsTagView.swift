//
//  ContentsTagView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

/// タグをフローレイアウトで表示するビュー。
///
/// このビューは、指定されたタグのリストをフローレイアウトで表示します。
/// 各タグは背景色付きのラベルとして表示され、コンテナの幅に応じて適切に折り返されます。
struct ContentsTagView: View {
    /// 表示するタグの配列。
    var tags: [String]
    /// タグを表示するコンテナの幅。
    var containerWidth: CGFloat
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dim in
                        if abs(width - dim.width) > containerWidth {
                            width = 0
                            height -= dim.height
                        }
                        let result = width
                        if tag == tags.last {
                            width = 0
                        } else {
                            width -= dim.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if tag == tags.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
    }

    /// タグのテキストを元に、表示用のビューを生成します。
    ///
    /// - Parameter text: 表示するタグのテキスト。
    /// - Returns: テキストを含むタグ表示用のビュー。
    private func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.footnote)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(30)
    }
}

#Preview {
    GeometryReader { geometry in
        ContentsTagView(
            tags: [
                "タグ１", "タグ２", "タグ３", "タグ4",
                "タグ5", "タグ6", "タグ7", "タグ8", "タグ9"],
            containerWidth: geometry.size.width)
    }
}
