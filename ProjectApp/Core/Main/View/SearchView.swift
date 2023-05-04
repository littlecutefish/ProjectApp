//
//  MapView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/20.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var vm : SearchViewModel
    @StateObject var homevm : HomeViewModel
    
    @State var searchButton: Bool = false
    @State var selectedMerchant: Bool = false
    @State var selectMerchantNot200 : Bool = false
    
    var body: some View {
        ZStack {
            // background
            Color.theme.loginBackground.edgesIgnoringSafeArea(.all)
            
            VStack {
                // 查詢店家的bar
                searchBarSection
                ZStack {
                    storeInformSection
                    searchSection
                    if !searchButton {
                        storeInformSection
                    }
                }
                .padding([.leading, .trailing],35)
            }
            
        }
    }
    
    // 查詢店家的Bar
    private var searchBarSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hex: ""))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "715428"), lineWidth: 2)
                )
            
            HStack{
                Image(systemName: "magnifyingglass")
                    .frame(width: 40)
                TextField("請輸入店家名稱...", text: $vm.merchantName)
                
                Button {
                    vm.searchMerchantName()
                    searchButton = true
                    selectedMerchant = false
                } label: {
                    Image(systemName: "arrow.turn.down.left")
                }
                .padding(5)
            }
            .foregroundColor(Color(hex: "715428"))
        }
        .frame(height: 50)
        .padding([.top, .leading, .trailing],30)
        
    }
    
    // 店家資訊
    private var storeInformSection: some View {
        VStack {
            HStack{
                Circle()
                    .foregroundColor(.white)
                    .overlay {
                        // TODO: 放照片
                        Text("photo")
                    }
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 180 ,height: 30)
                        .foregroundColor(Color(hex: "B08B2C").opacity(0.4))
                        .padding(.top, 20)
                    Text("店家資訊")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 180)
                }
                
                Image("LittleGirl")
                    .resizable()
                    .frame(width: 60, height: 50)
                    .padding(.bottom, -20)
            }
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white.opacity(0.4))
                VStack {
                    HStack {
                        Text(vm.showedMerchant.name == "" ? "店名" : vm.showedMerchant.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button {
                            // 保存資料到"我的最愛"
                            if !vm.showedMerchant.favorite {
                                vm.putIntoMyFavList(customerUid: vm.showedMerchant.customerUid,merchantUid: vm.showedMerchant.uid)
                            }
                            else {
                                vm.deleteMyFavItem(customerUid: vm.showedMerchant.customerUid,merchantUid: vm.showedMerchant.uid)
                            }
                            vm.showedMerchant.favorite.toggle()
                        } label: {
                            Image(systemName: vm.showedMerchant.favorite ? "star.fill" : "star")
                        }
                        .foregroundColor(Color(hex: "CD32DB"))
                    }.padding()
                    
                    HStack {
                        Text("地址：" + vm.showedMerchant.location)
                            .font(.title3)
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding()
                    
                    HStack {
                        Text("電話：" + vm.showedMerchant.phoneNumber)
                            .font(.title3)
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding()
                    
                    Divider()
                    
                    Text("店家介紹")
                        .font(.title3)
                        .fontWeight(.semibold)
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: "FFFBFB"))
                        .overlay {
                            Text(vm.showedMerchant.intro == "" ? "..." : vm.showedMerchant.intro)
                        }
                        .padding([.leading, .trailing, .bottom], 10)
                }
            }
            
            ZStack {
                Button {
                    // 紀錄被選擇的店家 食物資訊
                    dataShowInHomeView()
                    ShareInfoManager.shared.nowHomeMerchantUid = vm.showedMerchant.uid
                    selectedMerchant.toggle()
                    if selectedMerchant {
                        homevm.getTableInfo(merchantUid: vm.showedMerchant.uid)
                    }
                    else {
                        // 表示主頁不會顯示畫面
                        ShareInfoManager.shared.nowHomeMerchantUid = "-1"
                    }
//                    if homevm.nowStatus != 200 {
                        // TODO: 還有個BUG...
//                        merchantInfoHaveNoFood
//                    }
                } label: {
                    if selectedMerchant {
                        Text("已選擇店家")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .padding()
                            .frame(height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    } else {
                        Text("選擇顯示此店家")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .padding()
                            .frame(height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    }
                }
                .padding(5)
                
                HStack {
                    Spacer()
                    
                    Image(systemName: selectedMerchant ? "checkmark.square" : "square")
                        .foregroundColor(Color(hex: "715428"))
                }
                
            }
        }
    }
    
    private var merchantInfoHaveNoFood: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hex: "ECD2D2"))
            VStack{
                HStack {
                    Spacer()
                    Button {
                        homevm.nowStatus = 200
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                    }
                    Text("此商家尚未準備好")
                }
            }
            .frame(width: 200, height: 100)
        }
    }
    
    private var searchSection: some View {
        // 搜尋下拉bar
        VStack {
            if (searchButton) {
                // 顯示店家資訊頁面
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    VStack {
                        if vm.searchedMerchant.count > 0 {
                            ScrollView {
                                ForEach(vm.searchedMerchant.indices, id: \.self) { index in
                                    HStack {
                                        Button {
                                            // TODO: 按下按鈕後跟後端要店家資訊
                                            vm.getMerchantInfo(customerUid: vm.searchedMerchant[index].customerUid, merchantUid: vm.searchedMerchant[index].uid)
                                            
                                            clearMerchantData()
                                            clearSearchButton()
                                        } label: {
                                            Circle()
                                                .foregroundColor(.gray)
                                                .opacity(0.5)
                                                .overlay{
                                                    Image(systemName: "person.fill")
                                                }
                                            
                                            Text(vm.searchedMerchant[index].name).font(.title2)
                                            
                                            Spacer()
                                            
                                            Text(vm.searchedMerchant[index].location) // 放地址
                                                .font(.callout)
                                                .foregroundColor(.gray)
                                                .frame(width: 80)
                                        }
                                        .foregroundColor(.black)
                                        
                                        Button {
                                            // 保存資料到"我的最愛"
                                            if !vm.searchedMerchant[index].favorite {
                                                vm.putIntoMyFavList(customerUid: vm.searchedMerchant[index].customerUid,merchantUid: vm.searchedMerchant[index].uid)
                                            }
                                            else {
                                                vm.deleteMyFavItem(customerUid: vm.searchedMerchant[index].customerUid, merchantUid: vm.searchedMerchant[index].uid)
                                            }
                                            // TODO: 要把myFav資料存起來
                                            vm.searchedMerchant[index].favorite.toggle()
                                        } label: {
                                            Image(systemName: vm.searchedMerchant[index].favorite ? "star.fill" : "star")
                                        }
                                        .frame(width: 30)
                                        .foregroundColor(Color(hex: "D6B6D9"))
                                    }
                                    .frame(height: 60)
                                    .padding(5)
                                    Divider()
                                }
                            }.frame(height: 200)
                        }
                        else {
                            VStack{
                                Text("查無資料").font(.title)
                            }.frame(height: 200)
                        }
                        
                        // 取消查詢按鈕
                        Button {
                            searchButton = false
                            clearMerchantData()
                        } label: {
                            Text("取消查詢")
                                .foregroundColor(Color.black)
                                .padding(3)
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 2)
                                }
                        }
                        .shadow(radius: 2)
                        .frame(height: 25)
                    }
                    
                    
                    
                }
                .frame(height: 240)
            }
            Spacer()
        }
    }
    
    func clearSearchButton() {
        searchButton = false
    }
    
    func clearMerchantData() {
        vm.merchantName = ""
    }
    
    func dataShowInHomeView() {
        ShareInfoManager.shared.merchant = vm.showedMerchant
    }
}
