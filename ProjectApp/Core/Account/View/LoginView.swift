//
//  LoginView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/17.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm: LoginViewModel = LoginViewModel()
    @State var isShowNewAccountScreen: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                logoSection
                Spacer()
                bodySection
            }
            
            // 按下"建立一個新帳號"後，會彈出的窗口
            if isShowNewAccountScreen {
                selectCreateMode
            }
        }
    }
    
    private var logoSection: some View {
        Image("Logo")
            .background(
                Circle().foregroundColor(.white)
            )
    }
    
    private var bodySection: some View {
        VStack {
            // MARK: 向後端判斷帳號正確性
            TextFieldItem(account: $vm.account, password: $vm.password, name: "帳號")
                .frame(height: 100)
            
            TextFieldItem(account: $vm.account, password: $vm.password, name: "密碼")
                .frame(height: 100)
            
            // "確認"按鈕
            Button {
                // account 和 password 要跟後端確認帳號是否存在
                // 判斷正確後存值進vm.account & vm.password
                savePasswordToShareInfoManager()
                vm.login()
            } label: {
                VStack{
                    Text("確認")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(width: 100, height: 40)
                        .background {
                            Color(hex: "#715428")
                                .opacity(0.7)
                        }
                        .cornerRadius(30)
                    if !vm.rightAccount {
                        Text("請輸入正確的帳號與密碼")
                            .frame(height: 10)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .disabled(!vm.isCanLogin)
            
            // "建立新帳號"按鈕
            Button(action: {
                isShowNewAccountScreen.toggle()
            }, label: {
                Text("建立一個新帳號")
                    .foregroundColor(.black)
                    .underline()
            })
            .padding(.bottom, 80)
        }
    }
    
    private var selectCreateMode: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 300, height: 300)
                .shadow(radius: 10, x: 10, y: 10)
            
            VStack {
                HStack {
                    Spacer()
                    // 按Ｘ，關掉小視窗
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            isShowNewAccountScreen.toggle()
                        }
                }
                
                // 如果是顧客端的話，進入RegisterView（註冊）頁面
                NavigationLink(destination: RegisterView()) {
                    Text("我不是店家")
                }
                .withCustomModifier()
                .padding(30)
                
                Text("我是店家").withCustomModifier()
                Spacer()
            }
            .frame(width: 300, height: 300)
        }
    }
    
    func savePasswordToShareInfoManager() {
        ShareInfoManager.shared.password = vm.password
        ShareInfoManager.shared.showPassword = ""
        for _ in 0..<ShareInfoManager.shared.password.count {
            ShareInfoManager.shared.showPassword.append("*")
        }
    }
}

fileprivate struct TextFieldItem: View {
    @EnvironmentObject var vm: MainViewModel
    @Binding var account: String
    @Binding var password: String
    
    @State var showPassword: Bool = false
    
    var name: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 60)
                .foregroundColor(Color(hex: "#F2F1E1"))
            HStack {
                Text(name)
                    .fontWeight(.bold)
                    .frame(width: 135)
                Rectangle()
                    .foregroundColor(vm.backGroundColor)
                    .frame(width: 3)
                if name == "帳號" {
                    TextField("xxx@xxx.com", text: $account)
                } else {
                    if showPassword {
                        TextField("", text: $password)
                    } else {
                        SecureField("", text: $password)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .padding()
                            .foregroundColor(.black)
                    }
                }
            }
            .font(.title2)
        }
        .padding(20)
    }
}
