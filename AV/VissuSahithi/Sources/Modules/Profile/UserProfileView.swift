//
//  UserProfileView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import FirebaseAuth

@available(iOS 16.0, *)
struct UserProfileView: View {
    @EnvironmentObject private var authSession: AuthSession
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }
    
    private var name: String {
        authSession.user?.displayName ?? (language == .telugu ? "వినియోగదారు" : "User")
    }
    
    private var email: String {
        authSession.user?.email ?? ""
    }

    private var languageTitle: String {
        language == .telugu ? "భాష" : "Language"
    }

    private var profileTitle: String {
        language == .telugu ? "ప్రొఫైల్" : "Profile"
    }

    private var logoutTitle: String {
        language == .telugu ? "లాగ్ అవుట్" : "Logout"
    }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 86))
                        .foregroundColor(Color(hex: "#7B8FA8"))

                    Text(name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(hex: "#1E2A39"))

                    Text(email)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "#5B6472"))

                    HStack(spacing: 12) {
                        Text(languageTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1E2A39"))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)

                        Spacer()

                        Picker(languageTitle, selection: $selectedLanguage) {
                            ForEach(AppLanguage.allCases, id: \.rawValue) { option in
                                Text(option.displayName(for: language)).tag(option.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 220)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#E2E8F0"), lineWidth: 1)
                    )

                    Button(logoutTitle) {
                        try? authSession.signOut()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationTitle(profileTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            UserProfileView()
        }
    } else {
        EmptyView()
    }
}
