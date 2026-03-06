//
//  AVApp.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct AVApp: App {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            
            if isLoggedIn {
                MainTabsView()
            } else {
                SigninView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
