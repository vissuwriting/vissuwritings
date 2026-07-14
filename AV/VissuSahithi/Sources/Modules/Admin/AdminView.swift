//
//  AdminView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import PhotosUI
import AVFoundation
import UniformTypeIdentifiers
import Combine
import FirebaseAuth
import FirebaseFirestore

@available(iOS 16.0, *)
struct AdminView: View {
    private enum AdminSection: String, CaseIterable {
        case post = "Post"
        case overview = "Overview"
    }

    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @AppStorage(AppConstants.editModeStorageKey) private var isEditModeEnabled = false
    @State private var selectedSection = AdminSection.post

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var editModeTitle: String {
        language == .telugu ? "ఎడిట్ మోడ్" : "Edit Mode"
    }

    private var managementTitle: String {
        switch selectedSection {
        case .post:
            return language == .telugu ? "పోస్ట్ చేయండి" : "Post Content"
        case .overview:
            return language == .telugu ? "అవలోకనం" : "Overview"
        }
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
            AdminManagementItem(destination: .kavithalu, icon: "book.closed.fill", title: "Post Kavithalu ", subtitle: "Manage poetry collection", badge: "", iconBgHex: "#EDF1F4", iconHex: "#6C7A8A", badgeBgHex: "#EDF1F4", badgeHex: "#6C7A8A"),
            AdminManagementItem(destination: .stories, icon: "text.book.closed.fill", title: "Post Stories ", subtitle: "Manage stories and narrative content", badge: "", iconBgHex: "#E8F6EC", iconHex: "#56BA75", badgeBgHex: "#E8F6EC", badgeHex: "#56BA75"),
            AdminManagementItem(destination: .songs, icon: "music.note", title: "Post Songs ", subtitle: "Manage songs and audio ", badge: "", iconBgHex: "#FFECEC", iconHex: "#E07B7B", badgeBgHex: "#FFECEC", badgeHex: "#E07B7B")
                    ]
    }

    private var visibleManagementItems: [AdminManagementItem] {
        managementItems.filter { item in
            switch selectedSection {
            case .post:
                return [.kavithalu, .songs, .stories].contains(item.destination)
            case .overview:
                return [.userManagement, .contentModeration, .analytics].contains(item.destination)
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

                        if selectedSection == .overview {
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
                        }

                        Text(managementTitle)
                            .font(.system(size: 17, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#1D2430"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)

                        ForEach(visibleManagementItems) { item in
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
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#2A3342"))
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.subtitle)
                    .font(.system(size: 13, weight: .medium))
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
                    LazyVStack(spacing: 12) {
                        ForEach(users) { user in
                            Button { selectedUser = user } label: {
                                userCard(user)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(language == .telugu ? "యూజర్లు" : "Registered Users")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: observeUsers)
        .onDisappear {
            listener?.remove()
            listener = nil
        }
        .sheet(item: $selectedUser) { user in
            userDetailsSheet(user)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
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
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex: "#E5EAF1"), lineWidth: 1))
    }

    private func userDetailsSheet(_ user: AdminUserRecord) -> some View {
        NavigationStack {
            VStack(spacing: 18) {
                Text(user.initials)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 76, height: 76)
                    .background(Color(hex: "#5B9BD5"))
                    .clipShape(Circle())

                VStack(spacing: 5) {
                    Text(user.name).font(.title3.bold())
                    Text(user.email).foregroundColor(.secondary)
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
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                if user.id != Auth.auth().currentUser?.uid {
                    Button {
                        updateUser(user, blocked: !(user.blocked || user.accountStatus == "blocked"))
                    } label: {
                        Label(user.blocked || user.accountStatus == "blocked" ? "Unblock User" : "Block User", systemImage: user.blocked ? "lock.open.fill" : "hand.raised.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(user.blocked ? .green : .orange)

                    Button(role: .destructive) {
                        removeUser(user)
                    } label: {
                        Label("Remove User Access", systemImage: "person.crop.circle.badge.minus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding(10)
           
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { selectedUser = nil }
                }
            }
        }
    }

    private func detailRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).fontWeight(.medium)
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
                users = snapshot?.documents.map(AdminUserRecord.init) ?? []
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

    private func removeUser(_ user: AdminUserRecord) {
        Firestore.firestore().collection("users").document(user.id).updateData([
            "blocked": true,
            "accountStatus": "removed",
            "removedAt": FieldValue.serverTimestamp()
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

    var collectionName: String {
        switch self {
        case .kavithalu: return "kavithalu"
        case .songs: return "songs"
        case .stories: return "stories"
        }
    }

    func title(_ language: AppLanguage) -> String {
        switch self {
        case .kavithalu: return language == .telugu ? "కవిత పోస్ట్ చేయండి" : "Post Kavitha"
        case .songs: return language == .telugu ? "పాట పోస్ట్ చేయండి" : "Post Song"
        case .stories: return language == .telugu ? "కథ పోస్ట్ చేయండి" : "Post Story"
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
    private enum ContentLanguage: String, CaseIterable {
        case english = "English"
        case telugu = "Telugu"
    }

    let contentType: AdminContentType
    let language: AppLanguage

    @State private var contentLanguage = ContentLanguage.english
    @State private var title = ""
    @State private var category = ""
    @State private var content = ""
    @State private var author = ""
    @State private var summary = ""
    @State private var duration = ""
    @State private var audioURL = ""
    @State private var audioData: Data?
    @State private var audioFileName = ""
    @State private var showingAudioImporter = false
    @StateObject private var audioRecorder = AdminAudioRecorder()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showSavedAlert = false
    @State private var saveMessage = ""
    @State private var isSaving = false

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

                    if contentType == .kavithalu || contentType == .stories || contentType == .songs {
                        categoryPicker
                    }

                    if contentType == .songs {
                        songAudioPicker
                    }

                    if contentType == .stories {
                        adminField(title: contentLanguage == .telugu ? "రచయిత" : "Author", text: $author, placeholder: contentLanguage == .telugu ? "రచయిత పేరు" : "Enter author")
                        adminField(title: contentLanguage == .telugu ? "సారాంశం" : "Summary", text: $summary, placeholder: contentLanguage == .telugu ? "సారాంశం నమోదు చేయండి" : "Enter summary")
                    }

                    if contentType != .songs {
                        imagePicker
                    }

                    if contentType != .songs {
                      VStack(alignment: .leading, spacing: 8) {
                        Text(contentLanguage == .telugu ? "కంటెంట్" : "Content")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#1D2430"))

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $content)
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
                                    .foregroundColor(Color(hex: "#A1ACBC"))
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

                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#E5EAF1"), lineWidth: 1)
                )

                if isSaving {
                    ProgressView().frame(maxWidth: .infinity)
                }
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle(contentType.title(language))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                postButton
            }
        }
        .alert(saveMessage, isPresented: $showSavedAlert) {
            Button(language == .telugu ? "సరే" : "OK", role: .cancel) {}
        }
        .onChange(of: selectedPhoto) { newPhoto in
            guard let newPhoto else { return }
            Task {
                selectedImageData = try? await newPhoto.loadTransferable(type: Data.self)
            }
        }
        .fileImporter(
            isPresented: $showingAudioImporter,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            guard case .success(let urls) = result, let url = urls.first else { return }
            loadAudioFile(from: url)
        }
    }

    private var isPostDisabled: Bool {
        isSaving
        || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || (contentType != .songs && content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        || category.isEmpty
        || (contentType == .songs && audioData == nil)
    }

    private var postButton: some View {
        Button {
            postContent()
        } label: {
            Text(language == .telugu ? "పోస్ట్" : "Post")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: isPostDisabled ? "#AFCDEC" : "#2F82D8"))
        }
        .buttonStyle(.plain)
        .disabled(isPostDisabled)
    }

    private var contentEditorHeight: CGFloat {
        let explicitLines = content.components(separatedBy: .newlines).count
        let wrappedLines = max(1, Int(ceil(Double(content.count) / 34.0)))
        return max(48, CGFloat(max(explicitLines, wrappedLines)) * 24 + 24)
    }

    private func postContent() {
        isSaving = true
        if contentType == .songs {
            saveContent(imageData: nil)
            return
        }
        if let selectedImageData {
            guard let compressedImage = compressedImageData(from: selectedImageData) else {
                finishSaving(message: language == .telugu ? "చిత్రాన్ని సిద్ధం చేయలేకపోయాము." : "Could not prepare the selected image.")
                return
            }
            saveContent(imageData: compressedImage)
        } else {
            saveContent(imageData: nil)
        }
    }

    private func saveContent(imageData: Data?) {
        var data: [String: Any] = [
            "category": category.trimmingCharacters(in: .whitespacesAndNewlines),
            "languageCode": contentLanguage == .telugu ? "te" : "en",
            "createdAt": FieldValue.serverTimestamp()
        ]
        if let imageData { data["imageData"] = imageData }
        data[contentLanguage == .telugu ? "titleTelugu" : "title"] = title.trimmingCharacters(in: .whitespacesAndNewlines)

        let collection: String
        switch contentType {
        case .kavithalu:
            collection = "kavithalu"
            data[contentLanguage == .telugu ? "fullKavithaTelugu" : "fullKavitha"] = content
            data["likes"] = 0
        case .songs:
            collection = "songs"
            data[contentLanguage == .telugu ? "genreTelugu" : "genre"] = category
            if let audioData { data["audioData"] = audioData }
            data["audioFileName"] = audioFileName
            data["duration"] = audioDurationText
        case .stories:
            collection = "stories"
            data[contentLanguage == .telugu ? "authorTelugu" : "author"] = author
            data[contentLanguage == .telugu ? "summaryTelugu" : "summary"] = summary
            data[contentLanguage == .telugu ? "fullStoryTelugu" : "fullStory"] = content
            let wordCount = content.split { $0.isWhitespace || $0.isNewline }.count
            data["readMinutes"] = max(1, Int(ceil(Double(wordCount) / 200.0)))
        }

        Firestore.firestore().collection(collection).addDocument(data: data) { error in
            finishSaving(error: error)
            if error == nil { clearForm() }
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
        duration = ""; audioURL = ""; audioData = nil; audioFileName = ""
        selectedPhoto = nil; selectedImageData = nil
    }

    private var availableCategories: [String] {
        switch contentType {
        case .kavithalu:
            return Array(AppConstants.Kavithalu.categoryKeys.dropFirst())
        case .stories:
            return Array(AppConstants.Story.categories.dropFirst())
        case .songs:
            return AppConstants.Songs.categories
        }
    }

    private func categoryTitle(_ value: String) -> String {
        switch contentType {
        case .kavithalu:
            return AppConstants.Kavithalu.categoryLabel(for: value, language: contentLanguage == .telugu ? .telugu : .english)
        case .stories:
            return AppConstants.Story.categoryLabel(value, contentLanguage == .telugu ? .telugu : .english)
        case .songs:
            return value
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
                        .foregroundColor(category.isEmpty ? Color(hex: "#A1ACBC") : Color(hex: "#1D2430"))
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

    private var songAudioPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(contentLanguage == .telugu ? "ఆడియో" : "Audio")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            HStack(spacing: 10) {
                Button {
                    showingAudioImporter = true
                } label: {
                    Label(contentLanguage == .telugu ? "ఫైల్" : "Choose File", systemImage: "folder")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    toggleRecording()
                } label: {
                    Label(
                        audioRecorder.isRecording ? (contentLanguage == .telugu ? "ఆపు" : "Stop") : (contentLanguage == .telugu ? "రికార్డ్" : "Record"),
                        systemImage: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(audioRecorder.isRecording ? .red : Color(hex: "#2F82D8"))
            }

            if !audioFileName.isEmpty {
                HStack {
                    Image(systemName: "waveform.circle.fill")
                        .foregroundColor(Color(hex: "#59A26B"))
                    Text(audioFileName)
                        .lineLimit(1)
                    Spacer()
                    Button {
                        audioData = nil
                        audioFileName = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "#8A96A8"))
                    }
                    .buttonStyle(.plain)
                }
                .font(.system(size: 13, weight: .medium))
                .padding(12)
                .background(Color(hex: "#F7F9FC"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text(contentLanguage == .telugu ? "గరిష్ట ఆడియో పరిమాణం 700 KB" : "Maximum audio size: 700 KB")
                .font(.caption)
                .foregroundColor(Color(hex: "#8A96A8"))
        }
    }

    private var audioDurationText: String {
        guard let audioData, let player = try? AVAudioPlayer(data: audioData) else { return "0:00" }
        let seconds = Int(player.duration.rounded())
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    private func loadAudioFile(from url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        guard let data = try? Data(contentsOf: url) else {
            finishSaving(message: "Unable to read the selected audio file.")
            return
        }
        acceptAudio(data, name: url.lastPathComponent)
    }

    private func toggleRecording() {
        if audioRecorder.isRecording {
            if let recording = audioRecorder.stopRecording() {
                acceptAudio(recording, name: "Recording-\(Date().formatted(date: .numeric, time: .shortened)).m4a")
            }
        } else {
            do {
                try audioRecorder.startRecording()
            } catch {
                finishSaving(message: error.localizedDescription)
            }
        }
    }

    private func acceptAudio(_ data: Data, name: String) {
        guard data.count <= 700_000 else {
            finishSaving(message: language == .telugu ? "ఆడియో 700 KB కంటే తక్కువగా ఉండాలి." : "Audio must be smaller than 700 KB on the free plan.")
            return
        }
        audioData = data
        audioFileName = name
    }

    private func adminField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#1D2430"))

            TextField(placeholder, text: text, axis: .vertical)
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

private final class AdminAudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    private var recorder: AVAudioRecorder?
    private var recordingURL: URL?

    func startRecording() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .default)
        try session.setActive(true)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("admin-recording-\(UUID().uuidString).m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 22_050,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: 48_000,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        let recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder.delegate = self
        recorder.prepareToRecord()
        guard recorder.record() else {
            throw NSError(domain: "AudioRecorder", code: 1, userInfo: [NSLocalizedDescriptionKey: "Recording could not start."])
        }
        self.recorder = recorder
        recordingURL = url
        isRecording = true
    }

    func stopRecording() -> Data? {
        recorder?.stop()
        recorder = nil
        isRecording = false
        try? AVAudioSession.sharedInstance().setActive(false)
        guard let recordingURL else { return nil }
        return try? Data(contentsOf: recordingURL)
    }
}
