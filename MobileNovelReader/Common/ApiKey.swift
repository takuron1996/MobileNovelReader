//
//  ApiKey.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/03/07.
//

import CryptoKit
import Foundation

func createSignature(method: HttpMethod, url: URL, now: Date = Date()) -> String? {
    // 正規リクエストの作成
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "ja_JP")
    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        return nil
    }
    components.query = nil
    let urlStringWithoutQuery = components.url!.absoluteString
    let canonicalRequest = "\(method.rawValue)\n\(urlStringWithoutQuery)\n\(formatter.string(from: now))"

    // 正規リクエストから署名文字列を作成（ハッシュ）
    let signatureString = SHA256.hash(data: Data(canonicalRequest.utf8))

    // 署名の計算
    let key = SymmetricKey(data: Data(config.apiKey.utf8))
    let signature = HMAC<SHA256>.authenticationCode(for: Data(signatureString), using: key)
    return signature.map { String(format: "%02x", $0) }.joined()
}
