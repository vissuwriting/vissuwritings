//
//  AdminView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct AdminView: View {
    
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @AppStorage(AppConstants.editModeStorageKey) private var isEditModeEnabled = false
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var titleText: String {
        AppConstants.Dashboard.adminTabTitle(language)
    }

    private var editModeTitle: String {
        language == .telugu ? "ఎడిట్ మోడ్" : "Edit Mode"
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    HStack {
                        Text(editModeTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#1D2430"))

                        Spacer()

                        Toggle("", isOn: $isEditModeEnabled)
                            .labelsHidden()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                    )

                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
            }
        }
    }
}
