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

    private var editModeTitle: String {
        language == .telugu ? "ఎడిట్ మోడ్" : "Edit Mode"
    }

    private var managementTitle: String {
        language == .telugu ? "నిర్వహణ ఫంక్షన్లు" : "Management Functions"
    }

    private var managementItems: [AdminManagementItem] {
        if language == .telugu {
            return [
                AdminManagementItem(destination: .userManagement, icon: "person.2.badge.gearshape.fill", title: "యూజర్ మేనేజ్‌మెంట్", subtitle: "యూజర్ ఖాతాలు మరియు పాత్రలను నిర్వహించండి", badge: "", iconBgHex: "#EAF3FB", iconHex: "#53A6E8", badgeBgHex: "#EAF3FB", badgeHex: "#5FADE9"),
                AdminManagementItem(destination: .contentModeration, icon: "checkmark.shield.fill", title: "కంటెంట్ మోడరేషన్", subtitle: "సమర్పించిన కంటెంట్‌ను సమీక్షించి నియంత్రించండి", badge: "", iconBgHex: "#FFF1E6", iconHex: "#F09A52", badgeBgHex: "#FFF1E6", badgeHex: "#F09A52"),
                AdminManagementItem(destination: .analytics, icon: "chart.bar.xaxis", title: "అనలిటిక్స్ డాష్‌బోర్డ్", subtitle: "వివరణాత్మక వినియోగ గణాంకాలు చూడండి", badge: "", iconBgHex: "#F3ECFB", iconHex: "#B087D7", badgeBgHex: "#F3ECFB", badgeHex: "#B087D7"),
                AdminManagementItem(destination: .kavithalu, icon: "book.closed.fill", title: "కవితలు కంటెంట్", subtitle: "కవితల సేకరణను నిర్వహించండి", badge: "", iconBgHex: "#EDF1F4", iconHex: "#6C7A8A", badgeBgHex: "#EDF1F4", badgeHex: "#6C7A8A"),
                AdminManagementItem(destination: .songs, icon: "music.note", title: "పాటలు కంటెంట్", subtitle: "ఆడియో కంటెంట్‌ను నిర్వహించండి", badge: "", iconBgHex: "#FFECEC", iconHex: "#E07B7B", badgeBgHex: "#FFECEC", badgeHex: "#E07B7B"),
                AdminManagementItem(destination: .stories, icon: "text.book.closed.fill", title: "కథలు కంటెంట్", subtitle: "కథల కంటెంట్‌ను నిర్వహించండి", badge: "", iconBgHex: "#E8F6EC", iconHex: "#56BA75", badgeBgHex: "#E8F6EC", badgeHex: "#56BA75")
            ]
        }

        return [
            AdminManagementItem(destination: .userManagement, icon: "person.2.badge.gearshape.fill", title: "User Management", subtitle: "Manage user accounts and roles", badge: "", iconBgHex: "#EAF3FB", iconHex: "#53A6E8", badgeBgHex: "#EAF3FB", badgeHex: "#5FADE9"),
            AdminManagementItem(destination: .contentModeration, icon: "checkmark.shield.fill", title: "Content Moderation", subtitle: "Review and moderate submitted content", badge: "", iconBgHex: "#FFF1E6", iconHex: "#F09A52", badgeBgHex: "#FFF1E6", badgeHex: "#F09A52"),
            AdminManagementItem(destination: .analytics, icon: "chart.bar.xaxis", title: "Analytics Dashboard", subtitle: "View detailed usage statistics", badge: "", iconBgHex: "#F3ECFB", iconHex: "#B087D7", badgeBgHex: "#F3ECFB", badgeHex: "#B087D7"),
            AdminManagementItem(destination: .kavithalu, icon: "book.closed.fill", title: "Kavithalu Content", subtitle: "Manage poetry collection", badge: "", iconBgHex: "#EDF1F4", iconHex: "#6C7A8A", badgeBgHex: "#EDF1F4", badgeHex: "#6C7A8A"),
            AdminManagementItem(destination: .songs, icon: "music.note", title: "Songs Content", subtitle: "Manage songs and audio content", badge: "", iconBgHex: "#FFECEC", iconHex: "#E07B7B", badgeBgHex: "#FFECEC", badgeHex: "#E07B7B"),
            AdminManagementItem(destination: .stories, icon: "text.book.closed.fill", title: "Stories Content", subtitle: "Manage stories and narrative content", badge: "", iconBgHex: "#E8F6EC", iconHex: "#56BA75", badgeBgHex: "#E8F6EC", badgeHex: "#56BA75")
        ]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
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

                        Text(managementTitle)
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#1D2430"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)

                        ForEach(managementItems) { item in
                            NavigationLink(value: item.destination) {
                                managementCard(item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationDestination(for: AdminDestination.self) { destination in
                destinationView(for: destination) .tabBarHidden()
            }
        }
    }

    private func managementCard(_ item: AdminManagementItem) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: item.iconBgHex))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: item.icon)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: item.iconHex))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "#2A3342"))
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#95A1B2"))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            if !item.badge.isEmpty {
                Text(item.badge)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: item.badgeHex))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: item.badgeBgHex))
                    .clipShape(Capsule())
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "#AFB8C5"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#E8EDF4"), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func destinationView(for destination: AdminDestination) -> some View {
        switch destination {
        case .userManagement:
            AdminPlaceholderView(
                title: language == .telugu ? "యూజర్ మేనేజ్‌మెంట్" : "User Management",
                subtitle: language == .telugu ? "ఈ విభాగం త్వరలో అందుబాటులో ఉంటుంది." : "This section will be available soon."
            )
        case .contentModeration:
            AdminPlaceholderView(
                title: language == .telugu ? "కంటెంట్ మోడరేషన్" : "Content Moderation",
                subtitle: language == .telugu ? "ఈ విభాగం త్వరలో అందుబాటులో ఉంటుంది." : "This section will be available soon."
            )
        case .analytics:
            AdminPlaceholderView(
                title: language == .telugu ? "అనలిటిక్స్ డాష్‌బోర్డ్" : "Analytics Dashboard",
                subtitle: language == .telugu ? "ఈ విభాగం త్వరలో అందుబాటులో ఉంటుంది." : "This section will be available soon."
            )
        case .kavithalu:
            AdminPostContentView(contentType: .kavithalu, language: language)
        case .songs:
            AdminPostContentView(contentType: .songs, language: language)
        case .stories:
            AdminPostContentView(contentType: .stories, language: language)
        }
    }
}

private struct AdminManagementItem: Identifiable {
    var id: AdminDestination { destination }
    let destination: AdminDestination
    let icon: String
    let title: String
    let subtitle: String
    let badge: String
    let iconBgHex: String
    let iconHex: String
    let badgeBgHex: String
    let badgeHex: String
}

private enum AdminDestination: Hashable {
    case userManagement
    case contentModeration
    case analytics
    case kavithalu
    case songs
    case stories
}

private struct AdminPlaceholderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 14) {
                Image(systemName: "sparkles.rectangle.stack")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundColor(Color(hex: "#8A96A8"))

                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D2430"))
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "#8A96A8"))
                    .multilineTextAlignment(.center)
            }
            .padding(24)
        }
    }
}

private enum AdminContentType {
    case kavithalu
    case songs
    case stories

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "కవిత పోస్ట్ చేయండి" : "Post Kavitha"
        case .songs: return language == .telugu ? "పాట పోస్ట్ చేయండి" : "Post Song"
        case .stories: return language == .telugu ? "కథ పోస్ట్ చేయండి" : "Post Story"
        }
    }

    func subtitle(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "అడ్మిన్ కోసం కవితా కంటెంట్ పోస్ట్ స్క్రీన్" : "Admin-only posting screen for kavithalu content"
        case .songs: return language == .telugu ? "అడ్మిన్ కోసం పాటల కంటెంట్ పోస్ట్ స్క్రీన్" : "Admin-only posting screen for songs content"
        case .stories: return language == .telugu ? "అడ్మిన్ కోసం కథల కంటెంట్ పోస్ట్ స్క్రీన్" : "Admin-only posting screen for stories content"
        }
    }

    func bodyPlaceholder(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "కవితా పాఠ్యం" : "Kavitha content"
        case .songs: return language == .telugu ? "పాట లిరిక్స్ లేదా వివరాలు" : "Song lyrics or details"
        case .stories: return language == .telugu ? "కథ పూర్తి పాఠ్యం" : "Story full content"
        }
    }

    func heroIcon() -> String {
        switch self {
        case .kavithalu: return "book.closed.fill"
        case .songs: return "music.note"
        case .stories: return "text.book.closed.fill"
        }
    }
}

@available(iOS 16.0, *)
private struct AdminPostContentView: View {
    let contentType: AdminContentType
    let language: AppLanguage

    @State private var title = ""
    @State private var category = ""
    @State private var content = ""
    @State private var showSavedAlert = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: contentType.heroIcon())
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: "#2F82D8"))
                        .frame(width: 42, height: 42)
                        .background(Color(hex: "#EAF3FB"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(contentType.title(language))
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#1D2430"))

                        Text(contentType.subtitle(language))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#8A96A8"))
                    }
                }

                VStack(spacing: 12) {
                    adminField(
                        title: language == .telugu ? "శీర్షిక" : "Title",
                        text: $title,
                        placeholder: language == .telugu ? "శీర్షిక నమోదు చేయండి" : "Enter title"
                    )

                    adminField(
                        title: language == .telugu ? "వర్గం" : "Category",
                        text: $category,
                        placeholder: language == .telugu ? "వర్గం నమోదు చేయండి" : "Enter category"
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(language == .telugu ? "కంటెంట్" : "Content")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#1D2430"))

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $content)
                                .frame(minHeight: 180)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "#F7F9FC"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                                )

                            if content.isEmpty {
                                Text(contentType.bodyPlaceholder(language))
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(hex: "#A1ACBC"))
                                    .padding(.top, 20)
                                    .padding(.leading, 14)
                            }
                        }
                    }
                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                )

                Button {
                    showSavedAlert = true
                } label: {
                    Text(language == .telugu ? "పోస్ట్ చేయండి" : "Post Content")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color(hex: "#2F82D8"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .alert(language == .telugu ? "పోస్ట్ సేవ్ అయింది" : "Post saved", isPresented: $showSavedAlert) {
            Button(language == .telugu ? "సరే" : "OK", role: .cancel) {}
        }
    }

    private func adminField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            TextField(placeholder, text: text)
                .padding(.horizontal, 12)
                .padding(.vertical, 11)
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                )
        }
    }
}
