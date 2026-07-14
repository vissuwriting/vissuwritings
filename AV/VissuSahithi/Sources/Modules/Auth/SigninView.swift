//
//  SigninView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


@available(iOS 16.0, *)
struct SigninView: View {

    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {

                AppConstants.Signin.backgroundColor
                    .opacity(AppConstants.Signin.backgroundOpacity)
                    .ignoresSafeArea()

                IconPatternView()
                    .opacity(AppConstants.Signin.patternOpacity)
                    .ignoresSafeArea()

                brandHeader

                VStack(spacing: AppConstants.Signin.rootStackSpacing) {
                    Spacer().frame(height: AppConstants.Signin.topSpacerHeight)

                    WaveShape()
                        .fill(AppConstants.Signin.waveFillColor)
                        .ignoresSafeArea()
                        .overlay(formSection)
                }
            }
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
}

@available(iOS 16.0, *)
extension SigninView {
    
    var brandHeader: some View {
        VStack(spacing: AppConstants.Brand.contentSpacing) {
            VStack(spacing: AppConstants.Brand.titleSpacing) {
                HStack(spacing: 8) {
                    Text(AppConstants.Brand.primaryTitle(for: language))
                        .font(.system(size: AppConstants.Brand.primaryFontSize, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    AppConstants.Brand.primaryTextColor,
                                    AppConstants.Brand.secondaryTextColor
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Image(systemName: AppConstants.Brand.headerIcon)
                        .font(.system(size: AppConstants.Brand.headerIconSize, weight: .semibold))
                        .foregroundColor(AppConstants.Brand.iconColor)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(AppConstants.Brand.iconBackgroundColor)
                        )
                }

                Text(AppConstants.Brand.secondaryTitle(for: language))
                    .font(.system(size: AppConstants.Brand.secondaryFontSize, weight: .semibold, design: .serif))
                    .italic()
                    .kerning(AppConstants.Brand.secondaryKerning)
                    .foregroundColor(AppConstants.Brand.secondaryTextColor)
                    .offset(x: AppConstants.Brand.secondaryOffsetX)
            }

            Image(systemName: AppConstants.Brand.accentIcon)
                .font(.system(size: AppConstants.Brand.accentIconSize, weight: .semibold))
                .foregroundColor(AppConstants.Brand.secondaryTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, AppConstants.Brand.topPadding)
        .shadow(
            color: AppConstants.Brand.shadowColor,
            radius: AppConstants.Brand.shadowRadius,
            x: .zero,
            y: AppConstants.Brand.shadowYOffset
        )
    }
    
    var formSection: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppConstants.Signin.formSpacing) {
                
                Text(AppConstants.Signin.title(for: language))
                    .font(.system(size: AppConstants.Signin.headerFontSize, weight: .bold))
                
                
                
                /// Email Field
                HStack {
                    
                    Image(systemName: AppConstants.Signin.emailIcon)
                        .foregroundColor(AppConstants.Signin.textFieldIconColor)
                    
                    TextField(AppConstants.Signin.emailPlaceholder(for: language), text: $email)
                        .autocapitalization(.none)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                }
                .padding()
                .background(
                    Capsule()
                        .fill(AppConstants.Signin.fieldBackgroundColor)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            AppConstants.Signin.fieldBorderColor.opacity(AppConstants.Signin.fieldBorderOpacity),
                            lineWidth: AppConstants.Signin.fieldBorderLineWidth
                        )
                )
                
                
                /// Password Field
                HStack {
                    
                    Image(systemName: AppConstants.Signin.passwordIcon)
                        .foregroundColor(AppConstants.Signin.textFieldIconColor)
                    
                    SecureField(AppConstants.Signin.passwordPlaceholder(for: language), text: $password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit {
                            dismissKeyboard()
                        }
                }
                .padding()
                .background(
                    Capsule()
                        .fill(AppConstants.Signin.fieldBackgroundColor)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            AppConstants.Signin.fieldBorderColor.opacity(AppConstants.Signin.fieldBorderOpacity),
                            lineWidth: AppConstants.Signin.fieldBorderLineWidth
                        )
                )
                
                
                /// Forgot Password (Only when typing password)
                if focusedField == .password {
                    
                    HStack {
                        Spacer()
                        
                        Text(AppConstants.Signin.forgotPasswordTitle(for: language))
                            .foregroundColor(AppConstants.Signin.accentColor)
                            .font(.system(size: AppConstants.Signin.forgotPasswordFontSize))
                    }
                    .transition(.opacity)
                }
                
                
                Button {
                    dismissKeyboard()
                    signIn()
                } label: {
                    
                    Text(AppConstants.Signin.loginTitle(for: language))
                        .foregroundColor(AppConstants.Signin.foregroundOnAccentColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            (email.isEmpty || password.isEmpty)
                            ? AppConstants.Signin.backgroundColor.opacity(AppConstants.Signin.disabledButtonOpacity)
                            : AppConstants.Signin.backgroundColor
                        )
                        .cornerRadius(AppConstants.Signin.buttonCornerRadius)
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                .padding(.top, AppConstants.Signin.buttonTopPadding)

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                
                /// Bottom Text
                /// Bottom Text
                HStack {
                    Spacer()
                    
                    Text(AppConstants.Signin.noAccountTitle(for: language))
                        .foregroundColor(AppConstants.Signin.bottomTextColor)
                    
                    NavigationLink(destination: SignupView()) {
                        Text(AppConstants.Signin.signUpTitle(for: language))
                            .foregroundColor(AppConstants.Signin.accentColor)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                }
                .padding(.top, AppConstants.Signin.bottomSectionTopPadding)
            }
            .padding(.horizontal, AppConstants.Signin.formHorizontalPadding)
            .padding(.top, AppConstants.Signin.formTopPadding)
            .padding(.bottom, AppConstants.Signin.formTopPadding)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}


// MARK: - Keyboard Dismiss

@available(iOS 16.0, *)
extension SigninView {
    
    func dismissKeyboard() {
        focusedField = nil
    }

    func signIn() {
        errorMessage = nil
        isLoading = true

        Auth.auth().signIn(
            withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password
        ) { result, error in
            if let error {
                isLoading = false
                errorMessage = error.localizedDescription
                return
            }

            guard let user = result?.user else {
                isLoading = false
                errorMessage = "Unable to access this account."
                return
            }

            user.reload { _ in
                Firestore.firestore().collection("users").document(user.uid).getDocument { snapshot, firestoreError in
                    if let firestoreError {
                        isLoading = false
                        try? Auth.auth().signOut()
                        errorMessage = firestoreError.localizedDescription
                        return
                    }

                    guard let snapshot, snapshot.exists else {
                        isLoading = false
                        try? Auth.auth().signOut()
                        errorMessage = "No registered account profile was found for this user."
                        return
                    }

                    let profile = snapshot.data() ?? [:]
                    let status = (profile["accountStatus"] as? String ?? "active").lowercased()
                    let isBlocked = profile["blocked"] as? Bool ?? false

                    if isBlocked || status == "blocked" {
                        isLoading = false
                        try? Auth.auth().signOut()
                        errorMessage = "This account has been blocked. Please contact the administrator."
                        return
                    }

                    if status == "removed" || status == "inactive" {
                        isLoading = false
                        try? Auth.auth().signOut()
                        errorMessage = status == "removed"
                            ? "This account has been removed. Please contact the administrator."
                            : "This account is inactive. Please contact the administrator."
                        return
                    }

                    guard Auth.auth().currentUser?.isEmailVerified == true else {
                        isLoading = false
                        snapshot.reference.updateData(["emailVerified": false])
                        try? Auth.auth().signOut()
                        errorMessage = "Please verify your email using the link Firebase sent before logging in."
                        return
                    }

                    snapshot.reference.updateData([
                        "emailVerified": true,
                        "accountStatus": "active",
                        "lastLoginAt": FieldValue.serverTimestamp()
                    ]) { _ in
                        isLoading = false
                    }
                }
            }
        }
    }
}


struct WaveShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 65))
        
        path.addCurve(
            to: CGPoint(x: rect.width, y: 120),
            control1: CGPoint(x: rect.width * 0.25, y: 20),
            control2: CGPoint(x: rect.width * 0.75, y: 180)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SigninView()
    } else {
        EmptyView()
    }
}


struct IconPatternView: View {
    
    var body: some View {
        
        GeometryReader { geo in
            
            let cellWidth = geo.size.width / CGFloat(AppConstants.IconPattern.columns)
            
            ZStack {
                
                ForEach(0..<AppConstants.IconPattern.rows, id: \.self) { row in
                    ForEach(0..<AppConstants.IconPattern.columns, id: \.self) { col in
                        
                        Image(
                            systemName: AppConstants.IconPattern.icons[
                                (row + col) % AppConstants.IconPattern.icons.count
                            ]
                        )
                            .font(.system(size: AppConstants.IconPattern.iconFontSize))
                            .foregroundColor(.white.opacity(AppConstants.IconPattern.iconForegroundOpacity))
                            .rotationEffect(
                                .degrees(
                                    Double.random(
                                        in: AppConstants.IconPattern.rotationMin...AppConstants.IconPattern.rotationMax
                                    )
                                )
                            )
                            .position(
                                x: cellWidth * CGFloat(col) + cellWidth / 2,
                                y: AppConstants.IconPattern.cellHeight * CGFloat(row) + AppConstants.IconPattern.verticalOffset
                            )
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
