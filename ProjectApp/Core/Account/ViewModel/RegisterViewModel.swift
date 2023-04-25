//
//  RegisterViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/17.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    // Published Variable
    @Published var accountInform: [String] = ["", "", "", ""]
    
    @Published var isCanLogin: Bool = false
    
    // Private Variable
    private var cancellable = Set<AnyCancellable>()
    private var createUserURL = "http://120.126.151.186/API/eating/user/signin/customer"
    
    // Init Function
    init() {
        subscribeUserInfoNotEmpty()
    }
    
    // Public Function
    /// 創建帳號
    func createAccount() {
        let userInfo = UserInfoModel(name: accountInform[0], email: accountInform[1], password: accountInform[2])
        Task {
            let uploadResult = await DatabaseManager.shared.uploadData(to: createUserURL, data: userInfo)
            switch uploadResult {
            case .success(let returnedResult):
                switch returnedResult.1 {
                case 200:
                    print("✅ Create Success")
                    break
                default:
                    print(returnedResult.1)
                }
            case .failure(let errorStatus):
                print("Create Error: \(errorStatus.rawValue)")
            }
        }
    }
    
    // Subscribe Private Function
    private func subscribeUserInfoNotEmpty() {
        $accountInform
            .receive(on: DispatchQueue.main)
            // 使用 sink, 取得分別可以應對收到結束與收到元素的執行閉包設定方式
            .sink { [weak self] returnedUserInfo in
                // field 不為空
                for userInfo in returnedUserInfo {
                    if userInfo.isEmpty {
                        self?.isCanLogin = false
                        return
                    }
                }
                // 密碼 = 確認密碼
                if returnedUserInfo[2] != returnedUserInfo[3] {
                    self?.isCanLogin = false
                    return
                }
                // email 限制
                var temp: Bool = false
                for char in returnedUserInfo[1] {
                    if char == "@"{
                        temp = true
                    }
                }
                if !temp {
                    self?.isCanLogin = false
                    return
                }
                self?.isCanLogin = true
            }
            .store(in: &cancellable)
    }
}
