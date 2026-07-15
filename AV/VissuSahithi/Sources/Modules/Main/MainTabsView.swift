//
//  DashboardView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct MainTabsView: View {
    @EnvironmentObject private var authSession: AuthSession
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    init() {
        let borderColor = UIColor(red: 197 / 255, green: 211 / 255, blue: 225 / 255, alpha: 1)
        let selectedBackground = UIColor(red: 230 / 255, green: 239 / 255, blue: 235 / 255, alpha: 1)
        let selectedText = UIColor(red: 42 / 255, green: 78 / 255, blue: 63 / 255, alpha: 1)

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = borderColor
        appearance.stackedLayoutAppearance.selected.iconColor = selectedText
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedText]

        let indicatorSize = CGSize(width: 48, height: 40)
        let indicator = UIGraphicsImageRenderer(size: indicatorSize).image { _ in
            selectedBackground.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: indicatorSize), cornerRadius: 20).fill()
        }
        UITabBar.appearance().selectionIndicatorImage = indicator.resizableImage(
            withCapInsets: UIEdgeInsets(top: 19, left: 23, bottom: 19, right: 23),
            resizingMode: .stretch
        )
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().layer.borderWidth = 1.5
        UITabBar.appearance().layer.borderColor = borderColor.cgColor
        UITabBar.appearance().layer.cornerRadius = 24
        UITabBar.appearance().layer.masksToBounds = true
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
            
            
            if authSession.isAdmin {
                AdminView()
                    .tabItem {
                        Image(systemName: AppConstants.Dashboard.adminTabIcon)
                        Text(AppConstants.Dashboard.adminTabTitle(language))
                    }
            }
        }
    }
}
