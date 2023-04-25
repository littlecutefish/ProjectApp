//
//  LoggingStatus.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/9.
//

import SwiftUI

struct LoggingStatus: View {
    @StateObject var shareInfoManger = ShareInfoManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background
                Color.theme.loginBackground.edgesIgnoringSafeArea(.all)
                
                if shareInfoManger.isLogin {
                    // 判斷如果可以登入就進入Tab的頁面
                    MainView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

struct LoggingStatus_Previews: PreviewProvider {
    static var previews: some View {
        LoggingStatus()
            .environmentObject(MainViewModel())
    }
}
