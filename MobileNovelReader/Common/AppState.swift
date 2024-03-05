//
//  AppState.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/29.
//

import Foundation

class AppState: ObservableObject {
    @Published var isLogin: Bool
    @Published var showAlert: Bool = false
    init(){
        if KeyChainManager.shared.read(account: KeyChainTokenData.accessToken.rawValue) != nil {
            isLogin = true
        }else{
            isLogin = false
        }
    }
}

extension AppState: FetcherDelegate{
    func dataFetchedSuccessfully(data: Data) {
        // 成功時は必要なし
    }
    
    func dataFetchFailed() {
        DispatchQueue.main.async {
            self.showAlert = true
        }
    }
}
