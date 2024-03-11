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
    @State private var id = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isFaild = false
    var body: some View {
        NavigationStack {
            VStack {
                //TODO: 画像を表示予定
                Text("ログイン")
                    .font(.title)
                    .padding(.bottom, 80)
                
                createTextField(iconName: "person", field: TextField("ID", text: $id)
                    .keyboardType(.alphabet))
                
                if isPasswordVisible{
                    createTextField(iconName: "lock", field: TextField("Password", text: $password)
                        .keyboardType(.alphabet))
                    .overlay(passwordVisibilityToggle)
                }else{
                    createTextField(iconName: "lock", field: SecureField("Password", text: $password)
                        .keyboardType(.alphabet))
                    .overlay(passwordVisibilityToggle)
                }
                
                Button(action: {
                    login()
                }){
                    Text("Log In")
                        .padding(.vertical, 10)
                        .font(.headline)
                        .frame(width: 300)
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
                
                //TODO: ユーザー登録ページを後で作成
                NavigationLink(destination: TmpSignUpView()) {
                    Text("Sign Up")
                        .padding(.vertical, 10)
                        .font(.headline)
                        .frame(width: 300)
                        .background(Color.green.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }.padding(5)
                
                //TODO: パスワード忘れページを後で作成
                NavigationLink(destination: TmpForgotPasswordView()) {
                    Text("パスワードを忘れた方はこちら")
                        .font(.subheadline)
                        .frame(width: 300, alignment: .leading)
                        .padding(.trailing)
                }.padding(.bottom)
            }.alert("ログインに失敗しました。", isPresented: $isFaild) {
                // アクションを指定せずにOKボタンを表示
            } message: {
                Text("ログインできませんでした。IDかPasswordが正しいか確認してください。")
            }
        }
    }
    
    private func login(){
        Task{
            let passwordTokenBody = PasswordTokenBody(id: id, password: password)
            guard let request = ApiRequest(endpoint: TokenEndpoint(tokenBody: passwordTokenBody)).request else{
                throw FetchError.badRequest
            }
            let tokenData: TokenData? = try? await fetcher.fetchData(request: request)
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
    LoginDisplayView(appState: AppState(), fetcher: Fetcher(delegate: AppState()))
}
