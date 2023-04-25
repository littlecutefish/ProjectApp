//
//  LoginViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/17.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    // Published Variable
    @Published var account: String = ShareInfoManager.shared.account
    @Published var password: String = ShareInfoManager.shared.password
    
    @Published var isCanLogin: Bool = false
    
    var rightAccount: Bool = false
    
    // Private Variable
    private var isCanLoginCancellable: AnyCancellable? = nil
    private var loginDatabaseURL = "http://120.126.151.186/API/eating/user/login/customer"
    
    // Init Function
    init() {
        subscribeIsCanLogin()
    }
    
    // Public Function
    /// 登入帳號
    func login() {
        let loginUserInfo = UserInfoModel(name: "", email: account, password: password)
        Task {
            let queryResult = await DatabaseManager.shared.uploadData(to: loginDatabaseURL, data: loginUserInfo, httpMethod: "POST")
            switch queryResult {
            case .success(let returnedResult):
                let returnedData = returnedResult.0
                guard let userInfo = try? JSONDecoder().decode(UserInfoModel.self, from: returnedData) else {
                    return
                }
                await MainActor.run {
                    ShareInfoManager.shared.uid = userInfo.uid
                    ShareInfoManager.shared.account = userInfo.name
                    ShareInfoManager.shared.email = userInfo.email
                    ShareInfoManager.shared.isLogin.toggle()
                }
                self.rightAccount = true
                print(rightAccount)
                print(userInfo)
            case .failure(let errorStatus):
                self.rightAccount = false
                print(rightAccount)
                print(errorStatus.rawValue)
            }
        }
    }
    
    // Subscribe Private Function
    /// 監看帳號密碼是否都不為空
    func subscribeIsCanLogin() {
        isCanLoginCancellable = $account
            .combineLatest($password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedAccount, returnedPassword in
                self?.isCanLogin = !returnedAccount.isEmpty && !returnedPassword.isEmpty
            }
    }
}
