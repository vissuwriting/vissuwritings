//
//  UserProfileView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@available(iOS 16.0, *)
struct UserProfileView: View {
    @EnvironmentObject private var authSession: AuthSession
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @State private var profile: [String: Any] = [:]
    
    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }
    
    private var name: String {
        profile["name"] as? String ?? authSession.user?.displayName ?? (language == .telugu ? "వినియోగదారు" : "User")
    }
    
    private var email: String {
        profile["email"] as? String ?? authSession.user?.email ?? ""
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

            ScrollView(showsIndicators: false) {
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

                    profileDetails

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
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(profileTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadProfile)
    }

    private var profileDetails: some View {
        VStack(spacing: 0) {
            profileRow(language == .telugu ? "పాత్ర" : "Role", value: (profile["role"] as? String ?? authSession.role ?? "member").capitalized)
            Divider()
            profileRow(language == .telugu ? "స్థితి" : "Status", value: displayStatus)
            Divider()
            profileRow(language == .telugu ? "ఈమెయిల్ ధృవీకరణ" : "Email verification", value: emailVerifiedText)
            Divider()
            profileRow(language == .telugu ? "నమోదు" : "Registered", value: formattedDate(profile["createdAt"] as? Timestamp))
            Divider()
            profileRow(language == .telugu ? "చివరి లాగిన్" : "Last login", value: formattedDate(profile["lastLoginAt"] as? Timestamp))
        }
        .padding(.horizontal, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E2E8F0"), lineWidth: 1))
    }

    private var displayStatus: String {
        let status = (profile["accountStatus"] as? String ?? "active").lowercased()
        let blocked = profile["blocked"] as? Bool ?? false
        if blocked || status == "blocked" { return language == .telugu ? "బ్లాక్ చేయబడింది" : "Blocked" }
        if status == "inactive" { return language == .telugu ? "నిష్క్రియ" : "Inactive" }
        if status == "removed" { return language == .telugu ? "తొలగించబడింది" : "Removed" }
        return language == .telugu ? "యాక్టివ్" : "Active"
    }

    private var emailVerifiedText: String {
        let verified = profile["emailVerified"] as? Bool ?? authSession.user?.isEmailVerified ?? false
        return verified
            ? (language == .telugu ? "ధృవీకరించబడింది" : "Verified")
            : (language == .telugu ? "ధృవీకరించబడలేదు" : "Not verified")
    }

    private func profileRow(_ title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title).foregroundColor(Color(hex: "#7A8698"))
            Spacer(minLength: 12)
            Text(value)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .font(.system(size: 13))
        .padding(.vertical, 12)
    }

    private func formattedDate(_ timestamp: Timestamp?) -> String {
        guard let timestamp else { return language == .telugu ? "అందుబాటులో లేదు" : "Not available" }
        return timestamp.dateValue().formatted(date: .abbreviated, time: .shortened)
    }

    private func loadProfile() {
        guard let uid = authSession.user?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            profile = snapshot?.data() ?? [:]
        }
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
