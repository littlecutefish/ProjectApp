//
//  MapView.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/20.
//

import SwiftUI

struct SearchView: View {
    
    @State var merchantName: String = ""
    
    @State var searchButton: Bool = false
    
    var body: some View {
        ZStack {
            // background
            Color.theme.loginBackground.edgesIgnoringSafeArea(.all)
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: ""))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "715428"), lineWidth: 2)
                        )
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .frame(width: 40)
                        TextField("請輸入店家名稱...", text: $merchantName)
                        
                        Spacer()
                        Button {
                            searchButton.toggle()
                        } label: {
                            Image(systemName: "arrow.turn.down.left")
                        }
                        .foregroundColor(.black)
                        .padding()
                    }
                }
                .frame(height: 50)
                .padding([.top, .leading, .trailing],30)
                
                ZStack {
                    if (searchButton && merchantName != "") {
                        // 顯示店家資訊頁面
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 150)
                            .foregroundColor(.white)
                            
                        ScrollView {
                            HStack {
                                Circle()
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                                    .overlay{
                                        Image(systemName: "person.fill")
                                    }
                                Text("店家名稱").font(.title2)
                                Spacer()
                                Text("店家資訊")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 60)
                            .padding(5)
                            
                            Divider()
                        }
                        .frame(height: 150)
                    }
                }
                .padding([.leading, .trailing],35)
                
                Spacer()
            }
            
        }
    }
}
