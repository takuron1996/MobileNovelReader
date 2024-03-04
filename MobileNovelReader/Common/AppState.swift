//
//  AppState.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/29.
//

import Foundation
 
class AppState: ObservableObject {
    @Published var isLogin: Bool
    init(){
        if KeyChainManager.shared.read(account: KeyChainTokenData.accessToken.rawValue) != nil {
            isLogin = true
        }else{
            isLogin = false
        }
    }
}
 
