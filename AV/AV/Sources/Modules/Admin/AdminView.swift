//
//  AdminView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct AdminView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var titleText: String {
        AppConstants.Dashboard.adminTabTitle(language)
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    
                    Text(titleText)
                        .font(.largeTitle)
                    
                    Button(language == .telugu ? "లాగ్ అవుట్" : "Logout") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}
