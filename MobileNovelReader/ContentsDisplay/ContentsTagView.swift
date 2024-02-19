//
//  NovelInfoTagView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/11.
//

import SwiftUI

struct ContentsTagView: View {
    var tags: [String]
    var containerWidth: CGFloat
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > containerWidth {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == tags.last {
                            width = 0
                        } else {
                            width -= d.width
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
    
    func item(for text: String) -> some View {
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
        ContentsTagView(tags: ["タグ１", "タグ２", "タグ３","タグ4", "タグ5", "タグ6","タグ7", "タグ8", "タグ9"], containerWidth: geometry.size.width)
    }
    
}
