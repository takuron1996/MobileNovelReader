//
//  FollowData.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/20.
//

/// 小説のフォロー操作の結果を表すデータ構造体。
///
/// この構造体は、小説のフォローまたはフォロー解除のリクエストが成功したかどうかを示します。
struct FollowData: Codable {
    /// フォロー操作が成功したかどうかを示すブール値。
    let isSuccess: Bool
}

/// 小説のフォロー操作に使用されるリクエストボディ構造体。
///
/// この構造体は、特定の小説をフォローまたはフォロー解除するためのリクエストボディに使用されます。
struct FollowBody: Codable {
    /// フォロー対象の小説の識別コード。
    let ncode: String
}
