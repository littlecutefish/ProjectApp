//
//  MainView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/17.
//

import SwiftUI

struct MainView: View {
//    @EnvironmentObject var vm: MainViewModel
    
    @State var sidebarPressed: Bool = false
    @State var title: String = "主頁"
    @State var icon: String = "house.fill"
    @State var selectedTab = "main"
    
    @State var selectedTabItem: [String] = ["main", "account", "search"]
    
    // side bar menu
    @State var menuSidebarItem: [String] = ["我的帳號", "店家查詢", "最愛店家", "登出"]
    @State var menuSidebarIcon: [String] = ["person.fill", "magnifyingglass", "star.fill", "rectangle.portrait.and.arrow.right"]
    
    @State var cheakToLogOut: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                Color.theme.loginBackground
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // 最上面的top bar
                    topBarItem(sidebarPressed: $sidebarPressed, title: $title, icon: $icon)
                    
                    ZStack {
                        TabView(selection: $selectedTab)  {
                            // 左下方的主頁tabview
                            HomeView()
                                .tabItem {
                                    Image(systemName: "house.fill")
                                    Text("主頁")
                                }
                                .tag("main")
                                .onAppear{
                                    title = "主頁"
                                    icon = "house.fill"
                                    if sidebarPressed {
                                        sidebarPressed.toggle()
                                    }
                                }
                            
                            // 中下方的地圖tabview
                            SearchView(vm: SearchViewModel())
                                .tabItem {
                                    Image(systemName: "magnifyingglass")
                                    Text("店家查詢")
                                }
                                .tag("search")
                                .onAppear{
                                    title = "店家查詢"
                                    icon = "fork.knife"
                                    if sidebarPressed {
                                        sidebarPressed.toggle()
                                    }
                                }
                            
                            // 右下方的帳號tabview
                            AccountView(vm: AccountViewModel())
                                .tabItem {
                                    Image(systemName: "person")
                                    Text("帳號")
                                }
                                .tag("account")
                                .onAppear{
                                    title = "我的帳號"
                                    icon = "person.fill"
                                    if sidebarPressed {
                                        sidebarPressed.toggle()
                                    }
                                }
                        }
                        .onAppear() {
                            UITabBar.appearance().backgroundColor = .white
                        }
                        
                        // 如果點擊side bar的按鈕，會打開side bar欄
                        if sidebarPressed {
                            TopSideBarMenu
                            // TODO: 加入我的最愛
                        }

                        // 二次確認是否要登出
                        if cheakToLogOut {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color(hex: "ECD2D2"))
                                VStack{
                                    Text("您選擇要登出？")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding()
                                    HStack {
                                        Button {
                                            ShareInfoManager.shared.clearAll()
                                            ShareInfoManager.shared.isLogin.toggle()
                                        } label: {
                                            Text("確認登出")
                                                .padding()
                                                .background {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.black, lineWidth: 2)
                                                }
                                        }
                                        
                                        Button {
                                            sidebarPressed.toggle()
                                            cheakToLogOut.toggle()
                                        } label: {
                                            Text("取消")
                                                .padding()
                                                .background {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.black, lineWidth: 2)
                                                }
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .frame(height: 25)
                                }
                            }
                            .shadow(radius: 10)
                            .frame(width: 200, height: 150)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var TopSideBarMenu: some View {
        NavigationStack {
            HStack {
                Spacer()
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            // "我的帳號"和"查詢店家"按鈕
                            ForEach(0 ..< 2) { index in
                                Button(action: {
                                    selectedTab = selectedTabItem[index+1]
                                    title = menuSidebarItem[index]
                                    icon = menuSidebarIcon[index]
                                    sidebarPressed.toggle()
                                }, label: {
                                    HStack {
                                        Text(menuSidebarItem[index])
                                        Spacer()
                                        Image(systemName: menuSidebarIcon[index])
                                    }
                                })
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                Divider()
                            }
                            
                            // 我的最愛
                            Button(action: {
                                title = menuSidebarItem[2]
                                icon = menuSidebarIcon[2]
                                sidebarPressed.toggle()
                            }, label: {
                                HStack {
                                    Text(menuSidebarItem[2])
                                    Spacer()
                                    Image(systemName: menuSidebarIcon[2])
                                }
                            })
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            Divider()
                            
                            // 登出
                            Button(action: {
                                cheakToLogOut.toggle()
                            }, label: {
                                HStack {
                                    Text(menuSidebarItem[3])
                                    Spacer()
                                    Image(systemName: menuSidebarIcon[3])
                                }
                            })
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            Divider()
                        }
                        .padding()
                    }
                    .frame(width: 160, height: 150)
                    
                    Spacer()
                }
                .padding(.top, -5)
            }
        }
    }
}

// top bar
struct topBarItem: View {
    
    @Binding var sidebarPressed: Bool
    @Binding var title: String
    @Binding var icon: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(hex: "C3B7A9"))
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 35, height: 30)
                    .padding(.leading, 20)
                Text(title)
                    .frame(width: 100, alignment: .leading)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                // top bar 右上角三條線的按鈕
                ZStack{
                    Rectangle()
                        .foregroundColor(.white).opacity(0.7)
                    Button {
                        sidebarPressed.toggle()
                    } label: {
                        VStack {
                            ForEach(0..<3) { times in
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(height: 8)
                                    .foregroundColor(Color(hex: "363636").opacity(0.6))
                            }
                        }
                        .padding(3)
                    }
                }.frame(width: 60)
            }
        }
        .frame(height: 60)
    }
}

