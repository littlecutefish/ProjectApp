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
    private init() { }
    
    @Published var isLogin: Bool = false
    @Published var uid: String = ""
    @Published var account: String = ""
    @Published var password: String = ""
    @Published var showPassword: String = ""
    @Published var email: String = ""
    
    @Published var myFavMerchantID: [String] = []
        
    func clearAll() {
        self.account.removeAll()
        self.password.removeAll()
        self.showPassword.removeAll()
        self.email.removeAll()
    }
}
