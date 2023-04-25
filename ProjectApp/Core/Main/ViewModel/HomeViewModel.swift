//
//  HomeScreenViewModel.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/18.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    // Published Variable
    @Published var companyName : String = "小魚兒 好粗餐廳"
    @Published var numOfTable : Int = 0
    @Published var table: [TableInform] = []
    
    // Init Function
    init() {
        self.table = [
            // MARK: 需要跟後端拿 桌子的ID、桌子名稱、剩餘時間
            TableInform(name: "A", remainingTime: 1),
            TableInform(name: "B", remainingTime: 0),
            TableInform(name: "C", remainingTime: 5),
            TableInform(name: "D", remainingTime: 0),
            TableInform(name: "E", remainingTime: 0),
            TableInform(name: "F", remainingTime: 6)
        ]
        self.numOfTable = table.count
    }
    
    // Public Variable
    var sortedTable: [TableInform]{
        table.sorted(by: TableInform.sortByTime)
    }
    var emptyTablePressedDownScreen: [Bool] = []
    
    // 計算空桌數量
    func emptyTableCountFunc() -> Int {
        var count : Int = 0
        
        for index in self.table.indices {
            if self.table[index].remainingTime == 0 {
                count += 1
            }
        }
        return count
    }
    
    // 顯示空桌的桌號（存在string裏面）
    func emptyTableString(count: Int) -> String {
        var emptyTable: String = ""
        var temp: Int = 0
        
        // 先清空陣列
        self.emptyTablePressedDownScreen.removeAll()
        
        for index in self.table.indices {
            if self.table[index].remainingTime == 0 {
                emptyTable.append(self.table[index].name)
                self.emptyTablePressedDownScreen.append(true)
                temp += 1
                if temp != count {
                    emptyTable.append(",")
                }
            }
            else {
                self.emptyTablePressedDownScreen.append(false)
            }
        }
        return emptyTable
    }
}

struct TableInform: Identifiable {
    let id = UUID()
    var name : String
    var remainingTime : Int
    
    // 把所有桌子的時間做排序，最短的移到前面，
    static func sortByTime(_ t1: TableInform, _ t2: TableInform) -> Bool {
        return t1.remainingTime < t2.remainingTime
    }
}
