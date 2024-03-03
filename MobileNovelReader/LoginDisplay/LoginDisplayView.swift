//
//  LoginDisplayView.swift
//  MobileNovelReader
//
//  Created by 池上拓 on 2024/02/28.
//

import SwiftUI

struct LoginDisplayView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var fetcher: Fetcher
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isFaild: Bool = false
    var body: some View {
        VStack {
            //TODO: 画像を表示予定
            
            createTextField(iconName: "person", field: TextField("ID", text: $id).keyboardType(.asciiCapableNumberPad))
            
            if isPasswordVisible{
                createTextField(iconName: "lock", field: TextField("Password", text: $password).keyboardType(.asciiCapableNumberPad))
                    .overlay(passwordVisibilityToggle)
            }else{
                createTextField(iconName: "lock", field: SecureField("Password", text: $password))
                    .overlay(passwordVisibilityToggle)
            }
            
            //TODO: パスワード忘れ用の処理
            
            Button(action: {
                login()
            }){
                Text("Log In")
                    .padding(.horizontal, 80)
                    .padding(.vertical, 10)
                    .font(.subheadline)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
            }
        }.alert("ログインに失敗しました。", isPresented: $isFaild) {
            // アクションを指定せずにOKボタンを表示
        } message: {
            Text("ログインできませんでした。IDかPasswordが正しいか確認してください。")
        }
    }

    private func login(){
        Task{
            let passwordTokenBody = PasswordTokenBody(id: id, password: password)
            guard let request = ApiEndpoint.token(tokenBody: passwordTokenBody).request else{
                throw FetchError.badRequest
            }
            let tokenData: TokenData? = try? await Fetcher().fetchData(request: request)
            if let tokenData {
                try setTokenKeyChain(tokenData: tokenData)
                appState.isLogin = true
            }else{
                isFaild = true
            }
        }
    }
    
    private func createTextField<F: View>(iconName: String, field: F) -> some View{
        return HStack {
            Image(systemName: iconName)
            field
        }
        .padding()
        .padding(.bottom)
        .overlay(
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.gray)
                .padding(),
            alignment: .bottom
        )
    }
    
    private var passwordVisibilityToggle: some View {
        HStack {
            Spacer()
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(!isPasswordVisible ? .secondary : .blue)
            }
            .padding(.trailing, 30)
        }
    }
    
}

#Preview {
    LoginDisplayView(appState: AppState(), fetcher: Fetcher())
}
