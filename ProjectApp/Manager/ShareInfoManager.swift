//
//  ShareInfoManager.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/17.
//

import Foundation

class ShareInfoManager: ObservableObject {
    
    // Singleton
    static var shared = ShareInfoManager()
    private init() {
        self.merchant = MerchantInfoModel(customerUid: "",merchantUid: "", name: "")
        self.homeTable = TableInfoModel(merchantUid: "")
    }
    
    // User Info
    @Published var isLogin: Bool = false
    @Published var uid: String = ""
    @Published var account: String = ""
    @Published var password: String = ""
    @Published var showPassword: String = ""
    @Published var email: String = ""
    
    // Merchant Info
    @Published var merchant: MerchantInfoModel
//    @Published var myFavMerchants: [MerchantInfoModel] = []
    
    // Table Info
    @Published var homeTable: TableInfoModel
    @Published var nowHomeMerchantUid: String = ""
    @Published var nowStatusIsNot200 : Bool = false
    
    func clearAll() {
        self.account.removeAll()
        self.password.removeAll()
        self.showPassword.removeAll()
        self.email.removeAll()
    }
}
