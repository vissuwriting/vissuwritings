//
//  DashboardView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct MainTabsView: View {
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }
    
    var body: some View {
        
        TabView {
            
            KavithaluView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.kavithaluTabIcon)
                    Text(AppConstants.Dashboard.kavithaluTabTitle(language))
                }
            
            
            StoryView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.storyTabIcon)
                    Text(AppConstants.Dashboard.storyTabTitle(language))
                }
            
            
            SongsView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.songsTabIcon)
                    Text(AppConstants.Dashboard.songsTabTitle(language))
                }
            
            
            AdminView()
                .tabItem {
                    Image(systemName: AppConstants.Dashboard.adminTabIcon)
                    Text(AppConstants.Dashboard.adminTabTitle(language))
                }
        }
    }
}
