//
//  AdminView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import PhotosUI
import Combine
import FirebaseAuth
import FirebaseFirestore

extension Notification.Name {
    static let adminContentPosted = Notification.Name("adminContentPosted")
}

@available(iOS 16.0, *)
struct AdminView: View {
    private enum AdminSection: String, CaseIterable {
        case post = "Post"
        case overview = "Overview"
        case settings = "Settings"
    }

    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @AppStorage(AppConstants.editModeStorageKey) private var isEditModeEnabled = false
    @State private var selectedSection = AdminSection.post

    init() {
        let titleColor = UIColor(red: 29 / 255, green: 36 / 255, blue: 48 / 255, alpha: 1)
        let selectedBackground = UIColor(red: 190 / 255, green: 218 / 255, blue: 204 / 255, alpha: 1)
        let segmentBackground = UIColor(red: 232 / 255, green: 237 / 255, blue: 243 / 255, alpha: 1)
        let switchOffColor = UIColor(red: 190 / 255, green: 199 / 255, blue: 210 / 255, alpha: 1)

        UISegmentedControl.appearance().selectedSegmentTintColor = selectedBackground
        UISegmentedControl.appearance().backgroundColor = segmentBackground
        UISegmentedControl.appearance().layer.borderColor = UIColor(red: 174 / 255, green: 187 / 255, blue: 201 / 255, alpha: 1).cgColor
        UISegmentedControl.appearance().layer.borderWidth = 1
        UISegmentedControl.appearance().layer.cornerRadius = 9
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 14, weight: .semibold)],
            for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 14, weight: .bold)],
            for: .selected
        )

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        UISwitch.appearance().onTintColor = selectedBackground
        UISwitch.appearance().tintColor = switchOffColor
        UISwitch.appearance().backgroundColor = .clear
        UISwitch.appearance().layer.borderColor = switchOffColor.cgColor
        UISwitch.appearance().layer.borderWidth = 1.5
        UISwitch.appearance().layer.cornerRadius = 16
    }

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var editModeTitle: String {
        language == .telugu ? "ఎడిట్ మోడ్" : "Edit Mode"
    }

    private var managementItems: [AdminManagementItem] {
        if language == .telugu {
            return [
                AdminManagementItem(destination: .userManagement, icon: "person.2.badge.gearshape.fill", title: "యూజర్ మేనేజ్‌మెంట్", subtitle: "యూజర్ ఖాతాలు మరియు పాత్రలను నిర్వహించండి", badge: "", iconBgHex: "#EAF3FB", iconHex: "#53A6E8", badgeBgHex: "#EAF3FB", badgeHex: "#5FADE9"),
                AdminManagementItem(destination: .contentModeration, icon: "checkmark.shield.fill", title: "కంటెంట్ మోడరేషన్", subtitle: "సమర్పించిన కంటెంట్‌ను సమీక్షించి నియంత్రించండి", badge: "", iconBgHex: "#FFF1E6", iconHex: "#F09A52", badgeBgHex: "#FFF1E6", badgeHex: "#F09A52"),
                AdminManagementItem(destination: .analytics, icon: "chart.bar.xaxis", title: "అనలిటిక్స్ డాష్‌బోర్డ్", subtitle: "వివరణాత్మక వినియోగ గణాంకాలు చూడండి", badge: "", iconBgHex: "#F3ECFB", iconHex: "#B087D7", badgeBgHex: "#F3ECFB", badgeHex: "#B087D7"),
                AdminManagementItem(destination: .kavithalu, icon: "quote.bubble.fill", title: "కవితలు కంటెంట్", subtitle: "కవితల సేకరణను నిర్వహించండి", badge: "", iconBgHex: "#EDF1F4", iconHex: "#6C7A8A", badgeBgHex: "#EDF1F4", badgeHex: "#6C7A8A"),
                AdminManagementItem(destination: .stories, icon: "book.closed.fill", title: "కథలు కంటెంట్", subtitle: "కథల కంటెంట్‌ను నిర్వహించండి", badge: "", iconBgHex: "#E8F6EC", iconHex: "#56BA75", badgeBgHex: "#E8F6EC", badgeHex: "#56BA75")
            ]
        }

        return [
            AdminManagementItem(destination: .userManagement, icon: "person.2.badge.gearshape.fill", title: "User Management", subtitle: "Manage user accounts and roles", badge: "", iconBgHex: "#EAF3FB", iconHex: "#53A6E8", badgeBgHex: "#EAF3FB", badgeHex: "#5FADE9"),
            AdminManagementItem(destination: .contentModeration, icon: "checkmark.shield.fill", title: "Content Moderation", subtitle: "Review and moderate submitted content", badge: "", iconBgHex: "#FFF1E6", iconHex: "#F09A52", badgeBgHex: "#FFF1E6", badgeHex: "#F09A52"),
            AdminManagementItem(destination: .analytics, icon: "chart.bar.xaxis", title: "Analytics Dashboard", subtitle: "View detailed usage statistics", badge: "", iconBgHex: "#F3ECFB", iconHex: "#B087D7", badgeBgHex: "#F3ECFB", badgeHex: "#B087D7"),
            AdminManagementItem(destination: .kavithalu, icon: "quote.bubble.fill", title: "Post Kavithalu ", subtitle: "Manage poetry collection", badge: "", iconBgHex: "#EDF1F4", iconHex: "#6C7A8A", badgeBgHex: "#EDF1F4", badgeHex: "#6C7A8A"),
            AdminManagementItem(destination: .stories, icon: "book.closed.fill", title: "Post Stories ", subtitle: "Manage stories and narrative content", badge: "", iconBgHex: "#E8F6EC", iconHex: "#56BA75", badgeBgHex: "#E8F6EC", badgeHex: "#56BA75")
                    ]
    }

    private var visibleManagementItems: [AdminManagementItem] {
        managementItems.filter { item in
            switch selectedSection {
            case .post:
                return [.kavithalu, .stories].contains(item.destination)
            case .overview:
                return [.userManagement, .contentModeration, .analytics].contains(item.destination)
            case .settings:
                return false
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        Picker("Admin Section", selection: $selectedSection) {
                            ForEach(AdminSection.allCases, id: \.self) { section in
                                Text(section.rawValue).tag(section)
                            }
                        }
                        .pickerStyle(.segmented)
                        .colorScheme(.light)

                        ForEach(visibleManagementItems) { item in
                            NavigationLink(value: item.destination) {
                                managementCard(item)
                            }
                            .buttonStyle(.plain)
                        }

                        if selectedSection == .settings {
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
                                    .stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5)
                            )
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
            .toolbarColorScheme(.light, for: .navigationBar)
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
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#2A3342"))
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "#64748B"))
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
                .stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5)
        )
    }

    @ViewBuilder
    private func destinationView(for destination: AdminDestination) -> some View {
        switch destination {
        case .userManagement:
            AdminUserManagementView(language: language)
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
    case stories
}

private struct AdminUserRecord: Identifiable {
    let id: String
    let name: String
    let email: String
    let role: String
    let emailVerified: Bool
    let accountStatus: String
    let blocked: Bool
    let createdAt: Date?
    let lastLoginAt: Date?

    init(document: QueryDocumentSnapshot) {
        let data = document.data()
        id = document.documentID
        name = data["name"] as? String ?? "User"
        email = data["email"] as? String ?? "No email"
        role = data["role"] as? String ?? "member"
        emailVerified = data["emailVerified"] as? Bool ?? false
        accountStatus = (data["accountStatus"] as? String ?? "active").lowercased()
        blocked = data["blocked"] as? Bool ?? false
        createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
        lastLoginAt = (data["lastLoginAt"] as? Timestamp)?.dateValue()
    }

    var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        let value = parts.compactMap(\.first).map(String.init).joined()
        return value.isEmpty ? "U" : value.uppercased()
    }

    var displayStatus: String {
        if blocked || accountStatus == "blocked" { return "Blocked" }
        if accountStatus == "removed" { return "Removed" }
        if accountStatus == "inactive" { return "Inactive" }
        if !emailVerified { return "Not verified" }
        return "Active"
    }

    var statusColor: Color {
        switch displayStatus {
        case "Active": return Color(hex: "#3FA768")
        case "Not verified": return Color(hex: "#E59A36")
        default: return Color(hex: "#D9534F")
        }
    }
}

@available(iOS 16.0, *)
private struct AdminUserManagementView: View {
    let language: AppLanguage
    @State private var users: [AdminUserRecord] = []
    @State private var selectedUser: AdminUserRecord?
    @State private var listener: ListenerRegistration?
    @State private var errorMessage = ""

    var body: some View {
        Group {
            if users.isEmpty && errorMessage.isEmpty {
                ProgressView()
            } else if !errorMessage.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .font(.largeTitle)
                    Text("Unable to load users").font(.headline)
                    Text(errorMessage).font(.footnote).foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        HStack(spacing: 7) {
                            countBadge("Total", count: users.count, color: Color(hex: "#2F82D8"))
                            countBadge("Active", count: users.filter { $0.displayStatus == "Active" }.count, color: Color(hex: "#3FA768"))
                            countBadge("Blocked", count: users.filter { $0.displayStatus == "Blocked" }.count, color: Color(hex: "#D9534F"))
                            countBadge("Not Verified", count: users.filter { !$0.emailVerified }.count, color: Color(hex: "#E59A36"))
                        }

                        LazyVStack(spacing: 12) {
                            ForEach(users) { user in
                                Button { selectedUser = user } label: {
                                    userCard(user)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(language == .telugu ? "యూజర్లు" : "Registered Users")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "#1D2430"))
            }
        }
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear(perform: observeUsers)
        .onDisappear {
            listener?.remove()
            listener = nil
        }
        .sheet(item: $selectedUser) { user in
            userDetailsSheet(user)
                .presentationDetents([
                    .height(user.id == Auth.auth().currentUser?.uid ? 430 : 490),
                    .large
                ])
                .presentationDragIndicator(.visible)
        }
    }

    private func countBadge(_ title: String, count: Int, color: Color) -> some View {
        VStack(spacing: 3) {
            Text("\(count)")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(Color(hex: "#697588"))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5))
    }

    private func userCard(_ user: AdminUserRecord) -> some View {
        HStack(spacing: 12) {
            Text(user.initials)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 46, height: 46)
                .background(Color(hex: "#5B9BD5"))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#1D2430"))
                Text(user.email)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#7A8698"))
                    .lineLimit(1)
                Text(user.displayStatus)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(user.statusColor)
            }

            Spacer(minLength: 8)

            Text(user.role.capitalized)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: "#2F82D8"))
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Color(hex: "#EAF3FB"))
                .clipShape(Capsule())
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5))
    }

    private func userDetailsSheet(_ user: AdminUserRecord) -> some View {
        ZStack(alignment: .topLeading) {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 12) {
                Text(user.initials)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 76, height: 76)
                    .background(Color(hex: "#5B9BD5"))
                    .clipShape(Circle())

                VStack(spacing: 5) {
                    Text(user.name)
                        .font(.title3.bold())
                        .foregroundColor(Color(hex: "#1D2430"))
                    Text(user.email).foregroundColor(Color(hex: "#596579"))
                    HStack {
                        Text(user.role.capitalized)
                        Text("•")
                        Text(user.displayStatus).foregroundColor(user.statusColor)
                    }
                    .font(.subheadline.weight(.semibold))
                }

                VStack(spacing: 0) {
                    detailRow("Registered", value: formatted(user.createdAt))
                    Divider()
                    detailRow("Last login", value: formatted(user.lastLoginAt))
                    Divider()
                    detailRow("Email", value: user.emailVerified ? "Verified" : "Not verified")
                }
                .padding(.horizontal)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5)
                )

                if user.id != Auth.auth().currentUser?.uid {
                    Button {
                        updateUser(user, blocked: !(user.blocked || user.accountStatus == "blocked"))
                    } label: {
                        Label(user.blocked || user.accountStatus == "blocked" ? "Unblock" : "Block", systemImage: user.blocked ? "lock.open.fill" : "hand.raised.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(user.blocked || user.accountStatus == "blocked" ? .green : .orange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .frame(maxWidth: .infinity, alignment: .top)

            Button {
                selectedUser = nil
            } label: {
                Text("Close")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#2F82D8"))
                    .fixedSize()
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color(hex: "#C5D3E1"), lineWidth: 1))
            }
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.top, 14)
        }
        .preferredColorScheme(.light)
    }

    private func detailRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundColor(Color(hex: "#596579"))
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#1D2430"))
        }
        .font(.subheadline)
        .padding(.vertical, 12)
    }

    private func formatted(_ date: Date?) -> String {
        guard let date else { return "Never" }
        return date.formatted(date: .abbreviated, time: .shortened)
    }

    private func observeUsers() {
        guard listener == nil else { return }
        listener = Firestore.firestore().collection("users")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error {
                    errorMessage = error.localizedDescription
                    return
                }
                users = (snapshot?.documents.map(AdminUserRecord.init) ?? []).sorted { first, second in
                    let firstIsAdmin = first.role.lowercased() == "admin"
                    let secondIsAdmin = second.role.lowercased() == "admin"
                    if firstIsAdmin != secondIsAdmin { return firstIsAdmin }
                    return (first.createdAt ?? .distantPast) > (second.createdAt ?? .distantPast)
                }
                if let selectedID = selectedUser?.id {
                    selectedUser = users.first { $0.id == selectedID }
                }
            }
    }

    private func updateUser(_ user: AdminUserRecord, blocked: Bool) {
        Firestore.firestore().collection("users").document(user.id).updateData([
            "blocked": blocked,
            "accountStatus": blocked ? "blocked" : "active",
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error { errorMessage = error.localizedDescription }
            selectedUser = nil
        }
    }

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
                    .foregroundColor(Color(hex: "#596579"))

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

enum AdminContentType {
    case kavithalu
    case stories

    var collectionName: String {
        switch self {
        case .kavithalu: return "kavithalu"
        case .stories: return "stories"
        }
    }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "కవిత పోస్ట్ చేయండి" : "Post Kavitha"
        case .stories: return language == .telugu ? "కథ పోస్ట్ చేయండి" : "Post Story"
        }
    }

    func bodyPlaceholder(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "కవితా పాఠ్యం" : "Kavitha content"
        case .stories: return language == .telugu ? "కథ పూర్తి పాఠ్యం" : "Story full content"
        }
    }

    func heroIcon() -> String {
        switch self {
        case .kavithalu: return "quote.bubble.fill"
        case .stories: return "book.closed.fill"
        }
    }
}

@available(iOS 16.0, *)
struct AdminPostContentView: View {
    private enum ContentLanguage: String, CaseIterable {
        case english = "English"
        case telugu = "Telugu"
    }

    let contentType: AdminContentType
    let language: AppLanguage
    let editingDocumentID: String?
    @Environment(\.dismiss) private var dismiss

    @State private var contentLanguage = ContentLanguage.english
    @State private var title = ""
    @State private var category = ""
    @State private var content = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showSavedAlert = false
    @State private var saveMessage = ""
    @State private var isSaving = false

    init(
        contentType: AdminContentType,
        language: AppLanguage,
        editingDocumentID: String? = nil,
        initialTitle: String = "",
        initialCategory: String = "",
        initialContent: String = "",
        initialImageData: Data? = nil,
        isTelugu: Bool = false
    ) {
        self.contentType = contentType
        self.language = language
        self.editingDocumentID = editingDocumentID
        _contentLanguage = State(initialValue: isTelugu ? .telugu : .english)
        _title = State(initialValue: initialTitle)
        _category = State(initialValue: initialCategory)
        _content = State(initialValue: initialContent)
        _selectedImageData = State(initialValue: initialImageData)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                Picker("Content Language", selection: $contentLanguage) {
                    ForEach(ContentLanguage.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                VStack(spacing: 12) {
                    adminField(
                        title: contentLanguage == .telugu ? "శీర్షిక" : "Title",
                        text: $title,
                        placeholder: contentLanguage == .telugu ? "శీర్షిక నమోదు చేయండి" : "Enter title"
                    )

                    categoryPicker

                    if contentType == .stories {
                        adminField(title: contentLanguage == .telugu ? "రచయిత" : "Author", text: $author, placeholder: contentLanguage == .telugu ? "రచయిత పేరు" : "Enter author")
                        adminField(title: contentLanguage == .telugu ? "సారాంశం" : "Summary", text: $summary, placeholder: contentLanguage == .telugu ? "సారాంశం నమోదు చేయండి" : "Enter summary")
                    }

                    imagePicker

                    VStack(alignment: .leading, spacing: 8) {
                        Text(contentLanguage == .telugu ? "కంటెంట్" : "Content")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#1D2430"))

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $content)
                                .foregroundColor(Color(hex: "#1D2430"))
                                .frame(height: contentEditorHeight)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "#F7F9FC"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                                )

                            if content.isEmpty {
                                Text(contentType.bodyPlaceholder(contentLanguage == .telugu ? .telugu : .english))
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(hex: "#64748B"))
                                    .padding(.top, 20)
                                    .padding(.leading, 14)
                            }

                            if !content.isEmpty {
                                Button {
                                    content = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(hex: "#8A96A8"))
                                        .padding(12)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .buttonStyle(.plain)
                            }
                        }
                    }

                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#C5D3E1"), lineWidth: 1.5)
                )

                if isSaving {
                    ProgressView().frame(maxWidth: .infinity)
                }
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(editingDocumentID == nil ? contentType.title(language) : (language == .telugu ? "పోస్ట్ సవరించండి" : "Edit Post"))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "#1D2430"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 10) {
                if contentType == .kavithalu && editingDocumentID == nil {
                    laterButton
                }
                postButton
                }
            }
        }
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert(saveMessage, isPresented: $showSavedAlert) {
            Button(language == .telugu ? "సరే" : "OK", role: .cancel) {}
        }
        .onChange(of: selectedPhoto) { newPhoto in
            guard let newPhoto else { return }
            Task {
                selectedImageData = try? await newPhoto.loadTransferable(type: Data.self)
            }
        }
    }

    private var isPostDisabled: Bool {
        isSaving
        || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || category.isEmpty
    }

    private var postButton: some View {
        Button {
            postContent(publishNow: true)
        } label: {
            Text(editingDocumentID == nil ? (language == .telugu ? "పోస్ట్" : "Post") : (language == .telugu ? "అప్‌డేట్" : "Update"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .frame(height: 34)
                .background(Color(hex: isPostDisabled ? "#AFCDEC" : "#2F82D8"))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(isPostDisabled)
    }

    private var laterButton: some View {
        Button {
            postContent(publishNow: false)
        } label: {
            Text(language == .telugu ? "తర్వాత" : "Later")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: isPostDisabled ? "#AFCDEC" : "#64748B"))
                .padding(.horizontal, 12)
                .frame(height: 34)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color(hex: isPostDisabled ? "#D7E3EF" : "#CBD5E1"), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(isPostDisabled)
    }

    private var contentEditorHeight: CGFloat {
        let explicitLines = content.components(separatedBy: .newlines).count
        let wrappedLines = max(1, Int(ceil(Double(content.count) / 34.0)))
        return max(48, CGFloat(max(explicitLines, wrappedLines)) * 24 + 24)
    }

    private func postContent(publishNow: Bool) {
        isSaving = true
        if let selectedImageData {
            guard let compressedImage = compressedImageData(from: selectedImageData) else {
                finishSaving(message: language == .telugu ? "చిత్రాన్ని సిద్ధం చేయలేకపోయాము." : "Could not prepare the selected image.")
                return
            }
            saveContent(imageData: compressedImage, publishNow: publishNow)
        } else {
            saveContent(imageData: nil, publishNow: publishNow)
        }
    }

    private func saveContent(imageData: Data?, publishNow: Bool) {
        var data: [String: Any] = [
            "category": category.trimmingCharacters(in: .whitespacesAndNewlines),
            "languageCode": contentLanguage == .telugu ? "te" : "en"
        ]
        data[editingDocumentID == nil ? "createdAt" : "updatedAt"] = FieldValue.serverTimestamp()
        if let imageData { data["imageData"] = imageData }
        data[contentLanguage == .telugu ? "titleTelugu" : "title"] = title.trimmingCharacters(in: .whitespacesAndNewlines)

        let collection: String
        switch contentType {
        case .kavithalu:
            collection = "kavithalu"
            data[contentLanguage == .telugu ? "fullKavithaTelugu" : "fullKavitha"] = content
            if editingDocumentID == nil {
                data["likes"] = 0
                data["isPublished"] = publishNow
            }
        case .stories:
            collection = "stories"
            data[contentLanguage == .telugu ? "authorTelugu" : "author"] = author
            data[contentLanguage == .telugu ? "summaryTelugu" : "summary"] = summary
            data[contentLanguage == .telugu ? "fullStoryTelugu" : "fullStory"] = content
            let wordCount = content.split { $0.isWhitespace || $0.isNewline }.count
            data["readMinutes"] = max(1, Int(ceil(Double(wordCount) / 200.0)))
        }

        let completion: (Error?) -> Void = { error in
            finishSaving(error: error)
            if error == nil {
                NotificationCenter.default.post(name: .adminContentPosted, object: collection)
                if editingDocumentID == nil {
                    clearForm()
                } else {
                    dismiss()
                }
            }
        }

        if let editingDocumentID {
            Firestore.firestore().collection(collection).document(editingDocumentID).setData(data, merge: true, completion: completion)
        } else {
            Firestore.firestore().collection(collection).addDocument(data: data, completion: completion)
        }
    }

    private func finishSaving(error: Error?) {
        isSaving = false
        saveMessage = error?.localizedDescription ?? (language == .telugu ? "పోస్ట్ సేవ్ అయింది" : "Post saved")
        showSavedAlert = true
    }

    private func finishSaving(message: String) {
        isSaving = false
        saveMessage = message
        showSavedAlert = true
    }

    private func compressedImageData(from data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let maximumDimension: CGFloat = 1200
        let scale = min(1, maximumDimension / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }

        for quality in [0.72, 0.58, 0.44, 0.32] {
            if let result = resizedImage.jpegData(compressionQuality: quality), result.count <= 600_000 {
                return result
            }
        }
        return resizedImage.jpegData(compressionQuality: 0.25)
    }

    private func clearForm() {
        title = ""; category = ""; content = ""
        author = ""; summary = ""
        selectedPhoto = nil; selectedImageData = nil
    }

    private var availableCategories: [String] {
        switch contentType {
        case .kavithalu:
            return Array(AppConstants.Kavithalu.categoryKeys.dropFirst())
        case .stories:
            return Array(AppConstants.Story.categories.dropFirst())
        }
    }

    private func categoryTitle(_ value: String) -> String {
        switch contentType {
        case .kavithalu:
            return AppConstants.Kavithalu.categoryLabel(for: value, language: contentLanguage == .telugu ? .telugu : .english)
        case .stories:
            return AppConstants.Story.categoryLabel(value, contentLanguage == .telugu ? .telugu : .english)
        }
    }

    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(contentLanguage == .telugu ? "వర్గం" : "Category")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            Menu {
                ForEach(availableCategories, id: \.self) { option in
                    Button(categoryTitle(option)) { category = option }
                }
            } label: {
                HStack {
                    Text(category.isEmpty ? (contentLanguage == .telugu ? "వర్గాన్ని ఎంచుకోండి" : "Select category") : categoryTitle(category))
                        .foregroundColor(category.isEmpty ? Color(hex: "#64748B") : Color(hex: "#1D2430"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color(hex: "#8A96A8"))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 13)
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E5EAF1"), lineWidth: 1))
            }
        }
    }

    private var imagePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(contentLanguage == .telugu ? "చిత్రం" : "Image")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack(spacing: 10) {
                    Image(systemName: selectedImageData == nil ? "photo.badge.plus" : "checkmark.circle.fill")
                    Text(selectedImageData == nil
                         ? (contentLanguage == .telugu ? "చిత్రాన్ని ఎంచుకోండి" : "Choose Image")
                         : (contentLanguage == .telugu ? "చిత్రం ఎంపికైంది" : "Image Selected"))
                    Spacer()
                }
                .foregroundColor(Color(hex: selectedImageData == nil ? "#2F82D8" : "#59A26B"))
                .padding(.horizontal, 12)
                .padding(.vertical, 13)
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#E5EAF1"), lineWidth: 1))
            }

            if let selectedImageData,
               let previewImage = UIImage(data: selectedImageData) {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                    )
            }
        }
    }

    private func adminField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            TextField(
                "",
                text: text,
                prompt: Text(placeholder).foregroundColor(Color(hex: "#64748B")),
                axis: .vertical
            )
                .foregroundColor(Color(hex: "#1D2430"))
                .lineLimit(1...6)
                .padding(.leading, 12)
                .padding(.trailing, text.wrappedValue.isEmpty ? 12 : 38)
                .padding(.vertical, 11)
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                )
                .overlay(alignment: .trailing) {
                    if !text.wrappedValue.isEmpty {
                        Button {
                            text.wrappedValue = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(hex: "#8A96A8"))
                                .padding(11)
                        }
                        .buttonStyle(.plain)
                    }
                }
        }
    }
}
