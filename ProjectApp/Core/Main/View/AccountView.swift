//
//  AccountView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/19.
//

import SwiftUI

struct AccountView: View {
    @StateObject var vm : AccountViewModel
    
    @State var changeAccount: Bool = false
    
    // 帳號頁面上的密碼
    @State var show: Bool = false
    // 舊密碼, 新密碼, 確認新密碼
    @State var showPassword: [Bool] = [false, false, false]
    @State var changeAccountItem: [String] = ["帳號名稱", "電子信箱", "舊密碼", "新密碼", "確認新密碼"]
    
    @State var AccountIcon: [String] = ["person", "envelope", "lock"]
    @State var AccountItem: [String] = ["帳號名稱", "電子信箱", "密碼"]
    
    var isCanLogin: Bool {
        vm.tempAccountInform[0].count > 0 &&
        vm.tempAccountInform[1].count > 0
    }
    
    var body: some View {
        ZStack {
            // background
            Color.theme.loginBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // 頭貼（MARK: 還未增加可以選擇相片的功能）
                headStickerSection
                Spacer()
                bodySection
                Spacer()
            }
            
            // 如果要更改資料的話，就會彈出更改的視窗
            if changeAccount {
                changeAccountSection
            }
        }
    }
    
    private var headStickerSection : some View {
        Circle()
            .frame(width: 200)
            .foregroundColor(.white)
            .overlay {
                Image(systemName: "person")
                    .resizable()
                    .padding(50)
            }
            .padding(.top,10)
    }
    
    private var bodySection: some View {
        VStack{
            ForEach(AccountIcon.indices, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 60)
                        .foregroundColor(Color(hex: "#F2F1E1"))
                    
                    // 顯示個資的三個欄位
                    HStack {
                        Image(systemName: AccountIcon[0]).frame(width: 10).padding(.leading,20)
                        Text(AccountItem[0])
                            .multilineTextAlignment(.leading)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 60, alignment: .leading)
                        
                        Rectangle()
                            .frame(width: 3)
                            .foregroundColor(Color.theme.loginBackground)
                        
                        if index == 0 {
                            Text(ShareInfoManager.shared.account).frame(width: 180, alignment: .leading)
                        }
                        else if index == 1 {
                            Text(ShareInfoManager.shared.email).frame(width: 180, alignment: .leading)
                        }
                        else {
                            HStack {
                                if show {
                                    Text(ShareInfoManager.shared.password)
                                } else {
                                    Text(ShareInfoManager.shared.showPassword)
                                }
                                Spacer()
                                Button {
                                    show.toggle()
                                } label: {
                                    Image(systemName: show ? "eye" : "eye.slash")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                            }.frame(width: 180)
                        }
                        
                    }
                }
                .frame(height: 100)
                .padding(10)
            }
            
            // 按鈕"變更資料"
            Button {
                // 彈出"要更改資料"的視窗
                renewVariable()
                changeAccount.toggle()
            } label: {
                Text("修改資訊")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "715428"))
                    .frame(width: 110, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "715428"), lineWidth: 2)
                    )
            }.disabled(changeAccount)
        }
    }
    
    private var changeAccountSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(width: 300, height:500)
                .shadow(radius: 10, x: 10, y: 10)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        changeAccount.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }
                }
                
                // 修改帳號的介面
                ForEach(changeAccountItem.indices, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.loginBackground, lineWidth: 2)
                            .frame(height: 60)
                        HStack {
                            Text(changeAccountItem[index])
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 100, height: 60)
                            
                            Rectangle()
                                .frame(width: 2, height: 60)
                                .foregroundColor(Color.theme.loginBackground)
                            
                            if(index == 0 || index == 1){
                                TextField(vm.tempAccountInform[index], text: $vm.tempAccountInform[index])
                            }
                            else {
                                showPasswordView(showPassword: $showPassword[index-2], data: $vm.tempAccountInform[index])
                            }
                        }
                    }.padding(5)
                }
                
                HStack {
                    Button {
                        // 修改 ShareInfoManager 內的帳號、信箱、密碼
                        change()
                        // 資料更新到後端
                        vm.editAccount()
                        changeAccount.toggle()
                    } label: {
                        Text("確認更改")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .frame(width: 100, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    }.disabled(!passwordCorrectOrNot())
                    
                    Button {
                        changeAccount.toggle()
                    } label: {
                        Text("取消")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .frame(width: 100, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    }
                }
            }
            .frame(width: 300, height: 200)
        }
    }
    
    // 更新ShareInfoManager內的資料
    func change() {
        // 修改vm.account
        if vm.tempAccountInform[0] != "" {
            ShareInfoManager.shared.account = vm.tempAccountInform[0]
            print(ShareInfoManager.shared.account)
        }
        
        // 修改vm.email
        if vm.tempAccountInform[1] != "" {
            ShareInfoManager.shared.email = vm.tempAccountInform[1]
            print(ShareInfoManager.shared.email)
        }

        // 修改vm.password和vm.showPassword
        if (vm.tempAccountInform[2]  != "" && vm.tempAccountInform[3]  != "" && passwordCorrectOrNot()) {
            ShareInfoManager.shared.password = vm.tempAccountInform[3]
            ShareInfoManager.shared.showPassword = ""
            for _ in 0..<ShareInfoManager.shared.password.count {
                ShareInfoManager.shared.showPassword.append("*")
            }
            print(ShareInfoManager.shared.password)
        }
    }
    
    // 判斷修改的密碼與新密碼是否一樣
    func passwordCorrectOrNot() -> Bool {
        var canLogin : Bool = false
        if (vm.tempAccountInform[2] == "" &&
            vm.tempAccountInform[3] == "" &&
            vm.tempAccountInform[4] == "") ||
            (vm.tempAccountInform[2] != vm.tempAccountInform[3] &&
             vm.tempAccountInform[3] == vm.tempAccountInform[4]) &&
            vm.tempAccountInform[2] == ShareInfoManager.shared.password{
            canLogin = true
        }
        return canLogin
    }
    
    // 更新最新的temp
    func renewVariable() {
        vm.tempAccountInform = [
            ShareInfoManager.shared.account,
            ShareInfoManager.shared.email,
            "",
            "",
            ""
        ]
    }
}

struct showPasswordView: View {
    @Binding var showPassword: Bool
    @Binding var data: String
    
    var body: some View {
        HStack {
            if showPassword {
                TextField("", text: $data)
            } else {
                SecureField("", text: $data)
            }
            
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye" : "eye.slash")
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}

