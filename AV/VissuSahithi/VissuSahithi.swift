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

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        user = nil
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            guard let user else {
                self.user = nil
                self.role = nil
                self.isCheckingSession = false
                return
            }

            user.reload { [weak self] _ in
                guard let self else { return }
                guard let refreshedUser = Auth.auth().currentUser,
                      refreshedUser.isEmailVerified else {
                    self.user = nil
                    self.role = nil
                    self.isCheckingSession = false
                    return
                }

                Firestore.firestore().collection("users").document(refreshedUser.uid).getDocument { [weak self] snapshot, _ in
                    guard let self else { return }
                    guard let snapshot, snapshot.exists,
                          let role = snapshot.data()?["role"] as? String else {
                        try? Auth.auth().signOut()
                        self.user = nil
                        self.role = nil
                        self.isCheckingSession = false
                        return
                    }

                    self.role = role.lowercased()
                    self.user = refreshedUser
                    self.isCheckingSession = false
                }
            }
        }
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
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
