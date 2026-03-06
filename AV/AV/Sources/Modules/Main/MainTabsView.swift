//
//  DashboardView.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct MainTabsView: View {
    
    var body: some View {
        
        TabView {
            
            KavithaluView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.kavithaluTabIcon)
                    Text(AppConstants.Dashboard.kavithaluTabTitle)
                }
            
            
            StoryView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.storyTabIcon)
                    Text(AppConstants.Dashboard.storyTabTitle)
                }
            
            
            SongsView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.songsTabIcon)
                    Text(AppConstants.Dashboard.songsTabTitle)
                }
            
            
            AdminView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.adminTabIcon)
                    Text(AppConstants.Dashboard.adminTabTitle)
                }
        }
    }
}
