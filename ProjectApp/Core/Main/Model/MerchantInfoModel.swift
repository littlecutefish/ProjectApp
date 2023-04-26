//
//  MerchantInfoModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/25.
//

import Foundation

struct MerchantInfoModel: Identifiable, Codable {
    let uid: String
    let name: String
    let phoneNumber: String
    let location: String
    let intro: String
    let photo: String
    var myFav: Bool
    var id: String { uid }
}

extension MerchantInfoModel {
    init(name: String) {
        self.name = name
        self.uid = UUID().uuidString
        self.phoneNumber = ""
        self.location = ""
        self.photo = ""
        self.intro = ""
        self.myFav = false
    }
}

extension MerchantInfoModel {
    
    enum CodingKeys: CodingKey {
        case uid, name, phoneNumber, location, intro, photo, myFav
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let uid = try? container.decode(String.self, forKey: .uid) {
            self.uid = uid
        } else {
            self.uid = UUID().uuidString
        }
        if let name = try? container.decode(String.self, forKey: .name) {
            self.name = name
        } else {
            self.name = ""
        }
        if let phoneNumber = try? container.decode(String.self, forKey: .phoneNumber) {
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = ""
        }
        if let location = try? container.decode(String.self, forKey: .location) {
            self.location = location
        } else {
            self.location = ""
        }
        if let intro = try? container.decode(String.self, forKey: .intro) {
            self.intro = intro
        } else {
            self.intro = ""
        }
        if let photo = try? container.decode(String.self, forKey: .photo) {
            self.photo = photo
        } else {
            self.photo = ""
        }
        if let myFav = try? container.decode(Bool.self, forKey: .myFav) {
            self.myFav = myFav
        } else {
            self.myFav = false
        }
    }
}
