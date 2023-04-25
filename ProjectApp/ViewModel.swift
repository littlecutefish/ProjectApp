//
//  ViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/16.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isLogin: Bool = false
    let backGroundColor: Color = Color.theme.loginBackground
    
    // 顧客端的資訊
    var account: String
    var email: String
    var password: String
    var showPassword: String
    
    // 餐廳的資訊
    var companyName: String
    var companyAddress: String
    
    // 桌子的資訊
    var numOfTable : Int
    var table : [TableInform]
    var emptyTablePressedDownScreen: [Bool]
    
    var sortedTable: [TableInform] {
        table.sorted(by: TableInform.sortByTime)
    }
    
    init() {
        account = ""
        email = ""
        password = ""
        showPassword = ""
        
        companyName = "小魚兒 好粗餐廳"
        companyAddress = ""
        
        table = [
            TableInform(name: "A", remainingTime: 1),
            TableInform(name: "B", remainingTime: 0),
            TableInform(name: "C", remainingTime: 5),
            TableInform(name: "D", remainingTime: 0),
            TableInform(name: "E", remainingTime: 0),
            TableInform(name: "F", remainingTime: 6)
        ]
        numOfTable = self.table.count
        emptyTablePressedDownScreen = []
    }
}


extension View {
    func withCustomModifier() -> some View {
        modifier(CustomModifier())
    }
    
    func withCustomModifierForWaitingTime() -> some View {
        modifier(CustomModifierForWaitingTime())
    }
}

// "我不是店家"和"我是店家"的視窗
struct CustomModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(Color.black)
            .frame(width: 200, height: 30)
            .padding()
            .background {
                Color(hex: "E49A9A")
                    .opacity(0.6)
                    .cornerRadius(20)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
    }
}

// "剩餘等待時間"的視窗
struct CustomModifierForWaitingTime: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .frame(height: 25)
            .background(Color.white)
            .background(
                Rectangle()
                    .stroke(Color.black, lineWidth: 2)
            )
            .padding(4)
    }
}
