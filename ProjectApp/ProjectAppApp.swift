//
//  ProjectAppApp.swift
//  ProjectApp
//
//  Created by 劉俐妤 on 2023/4/9.
//

import SwiftUI

@main
struct ProjectAppApp: App {
    var body: some Scene {
        WindowGroup {
            LoggingStatus()
                .environmentObject(MainViewModel())
        }
    }
}
