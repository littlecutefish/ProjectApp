//
//  HomeScreenView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/18.
//

import SwiftUI

struct Object {
    let id = UUID()
    var name : String
    var selected : Bool
}

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel = HomeViewModel()
    
    @State var tableInformButton: Bool = false
    @State var emptyTableInformButton: Bool = false
    @State var emptyString : String = ""
    
    @State var currentWaitingArray = [
        Object(name: "不顯示", selected: true),
        Object(name: "最短剩餘時間", selected: false),
        Object(name: "所有桌子資訊", selected: false)
    ]
    
    @State var nowSelectedCheck: Int = 0
    @State var emptyTableCount: Int = 0
    
    var body: some View {
        ZStack {
            // 背景
            backgroundSection
            VStack {
                // 餐廳名稱
                companyNameSection
                ScrollView {
                    // 主要畫面
                    bodySection
                }
            }
            .padding(32)
            .onAppear {
                // 將"最短剩餘時間"的下拉bar，加入桌子的數量
                arrayAppend(startID: 0)
            }
            
            // MARK: 如果沒有店家資料 會顯示最初始畫面
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var backgroundSection: some View {
        ZStack {
            Color.theme.loginBackground.edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .padding(15)
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(hex: "C3B7A9"))
                .padding(25)
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(hex: "F2F1E1"))
                .padding(28)
        }
    }
    
    private var companyNameSection: some View {
        ZStack {
            Text(vm.companyName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 330)
            
            RoundedRectangle(cornerRadius: 20)
            // 下方底線的width = 35*字數:330
                .frame(width: 35*CGFloat(vm.companyName.count) <= 330 ? 35*CGFloat(vm.companyName.count) : 330 ,height: 30)
                .foregroundColor(Color(hex: "B08B2C").opacity(0.4))
                .padding(.top, 20)
        }
    }
    
    private var bodySection: some View {
        VStack{
            // 剩餘等待時間的 Hstack
            tableInformationButton
            
            ZStack {
                // waiting time screen
                VStack {
                    
                    // 等待剩餘時間的HStack
                    waitingTimeScreen
                        .padding(.bottom)
                    
                    // 空桌狀態的HStack
                    emptyTableInformScreen
                    
                    // 空桌狀態的Drop down screen
                    emptyTableDropDownScreen
                    
                    Spacer()
                }
                
                // table inform screen
                tableInformDropDownScreen
            }
            .padding(.top, -5)
        }
        .padding()

    }
    
    // 剩餘等待時間的Hstack
    private var tableInformationButton: some View {
        HStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.black.opacity(0.1))
                Text("剩餘等待時間")
                    .fontWeight(.bold)
            }.frame(width: 120)
            
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(hex: "D9D9D9"))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                HStack {
                    Text("最短剩餘時間")
                        .fontWeight(.bold)
                        .frame(width: 120)
                    
                    // 點擊往下的小icon點開table inform button
                    Button {
                        tableInformButton.toggle()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .rotationEffect(Angle(degrees: tableInformButton ? 180 : 0))
                    }
                    .frame(width: 20)
                }
            }
        }
        .frame(height: 40)
    }
    
    // 空桌狀態的Hstack
    private var emptyTableInformScreen: some View {
        HStack {
            Text("空桌狀態：\(vm.emptyTableCountFunc())")
                .fontWeight(.bold)
                .frame(width: 120)
            
            ZStack{
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(hex: "D9D9D9"))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                HStack {
                    // 顯示空桌的桌子名稱
                    Text("桌號 " + vm.emptyTableString(count: vm.emptyTableCountFunc()))
                        .fontWeight(.bold)
                        .frame(width: 120)
                    
                    // 點擊往下的小icon，點開empty table inform button
                    Button {
                        emptyTableInformButton.toggle()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                            .rotationEffect(Angle(degrees: tableInformButton ? 180 : 0))
                    }
                    .frame(width: 20)
                }
            }
        }
        .frame(height: 40)
    }
    
    // 等待時間的頁面
    private var waitingTimeScreen: some View {
        ZStack {
            // drop down bar 第一個按鈕選擇（不顯示）
            if nowSelectedCheck == 0 {
                // 不顯示
            }
            // drop down bar 第二個按鈕選擇（最短剩餘時間）
            else if nowSelectedCheck == 1 {
                // 使用TimeSort，判斷時間最短的
                TimeSort(vm: vm)
            }
            // drop down bar 第三個按鈕選擇（所有桌子資訊）
            else if nowSelectedCheck == 2 {
                Rectangle()
                    .frame(height: CGFloat(vm.table.count) * 35)
                    .foregroundColor(.black.opacity(0.1))
                
                // 顯示剩餘等待時間的screen
                VStack {
                    ForEach(0..<vm.numOfTable, id: \.self) { tableID in
                        HStack {
                            Text("\(vm.table[tableID].name)")
                                .frame(width: 80)
                                .withCustomModifierForWaitingTime()
                            
                            Image(systemName: "arrow.right")
                            
                            if vm.table[tableID].remainingTime == 0 {
                                Text("已為空桌")
                                    .frame(width: 120)
                                    .withCustomModifierForWaitingTime()
                            }
                            else {
                                Text("剩餘：\(vm.table[tableID].remainingTime)分鐘")
                                    .frame(width: 120)
                                    .withCustomModifierForWaitingTime()
                            }
                        }
                    }
                }
            }
            // drop down bar 其他的按鈕選擇（按下什麼桌子，就會顯示那些桌子）
            else {
                Rectangle()
                    .frame(height: 35)
                    .foregroundColor(.black.opacity(0.1))
                
                // 哪張桌子被選到，會打勾並更新array內的Bool
                if currentWaitingArray[nowSelectedCheck].selected {
                    // 顯示剩餘等待時間的screen
                    VStack {
                        HStack {
                            Text("\(vm.table[nowSelectedCheck-3].name)")
                                .frame(width: 80)
                                .withCustomModifierForWaitingTime()
                            
                            Image(systemName: "arrow.right")
                            
                            if vm.table[nowSelectedCheck-3].remainingTime == 0 {
                                Text("已為空桌")
                                    .frame(width: 120)
                                    .withCustomModifierForWaitingTime()
                            }
                            else {
                                Text("剩餘：\(vm.table[nowSelectedCheck-3].remainingTime)分鐘")
                                    .frame(width: 120)
                                    .withCustomModifierForWaitingTime()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // 最短剩餘時間的下拉view
    private var tableInformDropDownScreen: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    // 如果點擊下拉按鈕
                    if tableInformButton {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .shadow(radius: 5)
                        
                        ScrollView {
                            VStack {
                                // 有幾張桌子，就需要幾個資料
                                ForEach(currentWaitingArray.indices, id: \.self) { data in
                                    HStack {
                                        Text("\(currentWaitingArray[data].name)")
                                            .frame(width: 140, height: 30)
                                            .onTapGesture {
                                                currentWaitingArray[data].selected.toggle()
                                                arrayInit(data: data)
                                                tableInformButton.toggle()
                                                nowSelectedCheck = data
                                            }
                                        
                                        Spacer()
                                        
                                        // 判斷打勾
                                        if currentWaitingArray[data].selected {
                                            Image(systemName: "checkmark")
                                                .frame(height: 30)
                                                .padding(.trailing, 15)
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                    }
                }
                .frame(width: 180, height: 140)
            }
            Spacer()
        }
    }
    
    // 空桌的下拉view
    private var emptyTableDropDownScreen: some View {
        HStack {
            Spacer()
            ZStack {
                if emptyTableInformButton {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                    
                    ScrollView {
                        VStack {
                            ForEach(vm.table.indices, id: \.self) { data in
                                ZStack {
                                    // 判斷空桌狀態，如果是空的就多加綠色的背景
                                    if vm.emptyTablePressedDownScreen[data] == true {
                                        Rectangle()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .foregroundColor(Color(hex: "ACDCA0"))
                                    }
                                    Text("\(vm.table[data].name)")
                                }
                                .frame(height: 30)
                                Divider()
                            }
                        }
                    }
                }
            }
            .frame(width: 180, height: 140)
            .padding(.top, -3)
        }
    }
    
    // 在打勾前重設
    func arrayInit(data: Int) -> () {
        for temp in currentWaitingArray.indices {
            if temp == data { currentWaitingArray[temp].selected = true }
            else { currentWaitingArray[temp].selected = false }
        }
    }
    
    // 把最短剩餘時間的下拉欄append當前桌子數量。
    func arrayAppend(startID: Int) {
        var temp = startID
        for _ in vm.table {
            currentWaitingArray.append(Object(name: vm.table[temp].name, selected: false))
            temp += 1
        }
    }
    
//    // 計算空桌數量
//    func emptyTableCountFunc() -> Int {
//        var count : Int = 0
//        var temp: Int = 0
//        var emptyTable: String = ""
//
//        // clear emptyString
//        emptyString = ""
//
//        for index in vm.table.indices {
//            if vm.table[index].remainingTime == 0 {
//                count += 1
//                emptyString.append(vm.table[index].name)
//                emptyTablePressedDownScreen.append(true)
//                temp += 1
//                if temp != count {
//                    emptyTable.append(",")
//                }
//            }
//            else {
//                emptyTablePressedDownScreen.append(false)
//            }
//        }
//
//        return count
//    }
}

// 判斷"最短剩餘時間"的桌子
struct TimeSort: View {
    var temp: [TableInform] = []
    
    init(vm: HomeViewModel) {
        temp = vm.table.sorted(by: TableInform.sortByTime)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: CGFloat(countNumOfShortestTime(i: 0)) * 35)
                .foregroundColor(.black.opacity(0.1))
            
            VStack {
                ForEach(temp.indices, id: \.self) { index in
                    if temp[index].remainingTime == temp[0].remainingTime {
                        HStack {
                            // 顯示桌子名稱
                            Text("\(temp[index].name)")
                                .foregroundColor(.black)
                                .frame(width: 80, height: 25)
                                .background(Color.white)
                                .background(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .padding(4)
                            
                            Image(systemName: "arrow.right")
                            
                            // 顯示桌子當前資訊
                            if temp[index].remainingTime == 0 {
                                Text("已為空桌")
                                    .foregroundColor(.black)
                                    .frame(width: 120, height: 25)
                                    .background(Color.white)
                                    .background(
                                        Rectangle()
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                    .padding(4)
                            }
                            else {
                                Text("剩餘：\(temp[index].remainingTime)分鐘")
                                    .foregroundColor(.black)
                                    .frame(width: 120, height: 25)
                                    .background(Color.white)
                                    .background(
                                        Rectangle()
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 計算要顯示的桌子有幾個，去計算大小
    func countNumOfShortestTime(i: Int) -> Int {
        var c = i
        
        for index in temp.indices {
            if temp[index].remainingTime == temp[0].remainingTime {
                c += 1
            }
        }
        
        return c
    }
}
