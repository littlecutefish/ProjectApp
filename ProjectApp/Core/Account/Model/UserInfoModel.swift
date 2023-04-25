//
//  UserInfoModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/22.
//

import Foundation

struct UserInfoModel: Identifiable, Codable {
    let uid: String
    let name: String
    let email: String
    let password: String
    let phoneNumber: String
    let photo: String
    var id: String { uid }
}

extension UserInfoModel {
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
        self.uid = UUID().uuidString
        self.phoneNumber = ""
        self.photo = ""
    }
}
