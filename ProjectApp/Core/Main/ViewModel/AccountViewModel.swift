//
//  AccountViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/22.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    
    // Published Variable
    // 臨時建立的替代資料
    @Published var tempAccountInform: [String]
    
    // Private Variable
    private var editDatabaseURL = "http://120.126.151.186/API/eating/user/customer"
    
    // Init Function
    init() {
        self.tempAccountInform = [
            ShareInfoManager.shared.account,
            ShareInfoManager.shared.email,
            "",
            ""]
    }
    
    // Public Variable
    func editAccount() {
        let editUserInfo = UserInfoModel(
            uid: ShareInfoManager.shared.uid,
            name: ShareInfoManager.shared.account,
            email: ShareInfoManager.shared.email,
            password: ShareInfoManager.shared.password,
            phoneNumber: "",
            photo: ""
        )
        Task {
            let uploadResult = await DatabaseManager.shared.uploadData(to: editDatabaseURL, data: editUserInfo, httpMethod: "PUT")
            switch uploadResult {
            case .success(let returnedResult):
                switch returnedResult.1 {
                case 200:
                    print("✅ Edit Success")
                    break
                default:
                    print(returnedResult.1)
                }
            case .failure(let errorStatus):
                print(errorStatus.rawValue)
            }
        }
    }
}
