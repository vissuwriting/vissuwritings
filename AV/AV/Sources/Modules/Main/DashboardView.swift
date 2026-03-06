//
//  DashboardView.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct DashboardView: View {
    
    var body: some View {
        
        TabView {
            
            Adminview()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.homeTabIcon)
                    Text(AppConstants.Dashboard.homeTabTitle)
                }
            
            
            SearchView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.searchTabIcon)
                    Text(AppConstants.Dashboard.searchTabTitle)
                }
            
            
            NotificationsView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.alertsTabIcon)
                    Text(AppConstants.Dashboard.alertsTabTitle)
                }
            
            
            ProfileView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.profileTabIcon)
                    Text(AppConstants.Dashboard.profileTabTitle)
                }
        }
    }
}
