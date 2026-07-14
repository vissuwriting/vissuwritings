//
//  VissuSahithi.swift
//  VissuSahithi
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@MainActor
final class AuthSession: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var role: String?
    @Published private(set) var isCheckingSession = true
    @Published private(set) var accessMessage: String?

    private var authListener: AuthStateDidChangeListenerHandle?
    private var profileTimer: Timer?
    private var isCheckingProfile = false

    init() {
        user = nil
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            guard let user else {
                self.stopProfileMonitoring()
                self.user = nil
                self.role = nil
                self.isCheckingSession = false
                return
            }

            user.reload { [weak self] _ in
                guard let self else { return }
                guard let refreshedUser = Auth.auth().currentUser,
                      refreshedUser.isEmailVerified else {
                    try? Auth.auth().signOut()
                    self.user = nil
                    self.role = nil
                    self.isCheckingSession = false
                    return
                }

                self.startProfileMonitoring(for: refreshedUser)
            }
        }
    }

    deinit {
        profileTimer?.invalidate()
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    func signOut() throws {
        stopProfileMonitoring()
        try Auth.auth().signOut()
    }

    private func startProfileMonitoring(for user: User) {
        stopProfileMonitoring()
        checkProfile(for: user)
        profileTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self, weak user] _ in
            guard let self, let user else { return }
            Task { @MainActor in
                self.checkProfile(for: user)
            }
        }
    }

    private func stopProfileMonitoring() {
        profileTimer?.invalidate()
        profileTimer = nil
        isCheckingProfile = false
    }

    private func checkProfile(for checkedUser: User) {
        guard !isCheckingProfile,
              Auth.auth().currentUser?.uid == checkedUser.uid else { return }
        isCheckingProfile = true

        Firestore.firestore().collection("users").document(checkedUser.uid).getDocument { [weak self] snapshot, error in
            guard let self else { return }
            self.isCheckingProfile = false

            guard Auth.auth().currentUser?.uid == checkedUser.uid else { return }

            guard error == nil,
                  let snapshot, snapshot.exists,
                  let profile = snapshot.data(),
                  let role = profile["role"] as? String else {
                self.accessMessage = "Your account profile could not be accessed. Please contact the administrator."
                self.stopProfileMonitoring()
                try? Auth.auth().signOut()
                self.user = nil
                self.role = nil
                self.isCheckingSession = false
                return
            }

            let status = (profile["accountStatus"] as? String ?? "active").lowercased()
            let blocked = profile["blocked"] as? Bool ?? false
            let accessDenied = blocked || ["blocked", "inactive", "removed"].contains(status)

            guard !accessDenied else {
                self.accessMessage = status == "removed"
                    ? "Your account access has been removed by an administrator."
                    : status == "inactive"
                        ? "Your account is inactive. Please contact the administrator."
                        : "Your account has been blocked by an administrator."
                self.stopProfileMonitoring()
                try? Auth.auth().signOut()
                self.user = nil
                self.role = nil
                self.isCheckingSession = false
                return
            }

            self.role = role.lowercased()
            self.user = checkedUser
            self.isCheckingSession = false
        }
    }

    func consumeAccessMessage() -> String? {
        defer { accessMessage = nil }
        return accessMessage
    }

    var isAdmin: Bool {
        role == "admin"
    }
}

@available(iOS 16.0, *)
@main
struct AVApp: App {

    @StateObject private var authSession: AuthSession

    init() {
        FirebaseApp.configure()
        _authSession = StateObject(wrappedValue: AuthSession())
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authSession.isCheckingSession {
                    ProgressView()
                } else if authSession.user != nil {
                    MainTabsView()
                } else {
                    SigninView()
                }
            }
            .environmentObject(authSession)
        }
    }
}
