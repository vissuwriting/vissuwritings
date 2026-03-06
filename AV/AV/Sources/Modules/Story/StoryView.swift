//
//  StoryView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct StoryView: View {
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var titleText: String {
        AppConstants.Dashboard.storyTabTitle(language)
    }

    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                Text(titleText)
                    .font(.largeTitle)
            }
        }
    }
}
