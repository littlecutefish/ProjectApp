//
//  MapView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/20.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var vm : SearchViewModel
    
    @State var searchButton: Bool = false
    
    @State var favorateButton: Bool = false
    @State var favorateButton2: Bool = false
    
    @State var selectedMerchant: Bool = false
    
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
                        Text("店名")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Button {
                            // 保存資料到"我的最愛"
                            favorateButton2.toggle()
                        } label: {
                            if favorateButton2 {
                                Image(systemName: "star.fill")
                            } else {
                                Image(systemName: "star")
                            }
                        }
                        .foregroundColor(Color(hex: "CD32DB"))
                    }.padding()
                    
                    HStack {
                        Text("地址")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding()
                    
                    Divider()
                    
                    Spacer()
                    
                    Text("店家介紹")
                        .font(.title3)
                        .fontWeight(.semibold)
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: "FFFBFB"))
                        .overlay {
                            Text("店家Info")
                        }
                        .padding([.leading, .trailing, .bottom], 10)
                }
            }
            
            ZStack {
                Button {
                    // 查詢頁面更新
                    // 紀錄被選擇的店家 食物資訊
                    selectedMerchant.toggle()
                } label: {
                    if(selectedMerchant) {
                        Text("已選擇店家")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .frame(width: 100, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    } else {
                        Text("選擇店家")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "715428"))
                            .frame(width: 100, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "715428"), lineWidth: 2)
                            )
                    }
                }
                .padding(5)
                
                HStack {
                    Spacer()
                    
                    if selectedMerchant {
                        Image(systemName: "checkmark.square")
                            .foregroundColor(Color(hex: "715428"))
                    }
                    else {
                        Image(systemName: "square")
                            .foregroundColor(Color(hex: "715428"))
                    }
                }
                
            }
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
                                            vm.searchedMerchant[index].myFav.toggle()
                                            
                                            // TODO: 要把myFav資料存起來
                                        } label: {
                                            if vm.searchedMerchant[index].myFav {
                                                Image(systemName: "star.fill")
                                            } else {
                                                Image(systemName: "star")
                                            }
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
}
