//
//  KeyChainManager.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/29.
//

import Foundation

/// 参考
/// [Keychainでデータをセキュリティを高めてローカルに保存する方法](https://appdev-room.com/swift-keychain)
/// [iOS | KeyChain への保存、読込、削除処理を実装する](https://zenn.dev/u_dai/articles/c90b3c62ef2251)
class KeyChainManager{
    static let shared = KeyChainManager()
    private let service = "MobileNovelReader"
    private init(){}
    
    func save(_ stringData: String, account: String) -> Bool {
        let data: Data = stringData.data(using: .utf8)!
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let matchingStatus = SecItemCopyMatching(query, nil)
        switch matchingStatus {
        case errSecItemNotFound:
            // データが存在しない場合は保存
            let status = SecItemAdd(query, nil)
            return status == noErr
        case errSecSuccess:
            // データが存在する場合は更新
            SecItemUpdate(query, [kSecValueData as String: data] as CFDictionary)
            return true
        default:
            print("keychainへの保存を失敗しました。")
            return false
        }
    }
    
    func read(account: String) -> String? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let data = (result as? Data) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func delete(account: String) -> Bool {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == noErr
    }
}

enum KeyChainError: Error{
    case FailureSave
    case FailureRead
    case FailureDelete
}

enum KeyChainTokenData: String{
    case accessToken
    case refreshToken
}

func setTokenKeyChain(tokenData: TokenData) throws{
    let tokenList = [
        (KeyChainTokenData.accessToken.rawValue, tokenData.accessToken),
        (KeyChainTokenData.refreshToken.rawValue, tokenData.refreshToken)
    ]
    
    for (account, token) in tokenList {
        guard KeyChainManager.shared.save(token, account: account) else{
            print("tokenの保存に失敗しました。")
            throw KeyChainError.FailureSave
        }
    }
}

func deleteTokenKeyChain() {
    _ = KeyChainManager.shared.delete(account: KeyChainTokenData.accessToken.rawValue)
    _ = KeyChainManager.shared.delete(account: KeyChainTokenData.refreshToken.rawValue)
}
