//
//  SignupView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct SignupView: View {
    
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    enum Field {
        case name
        case email
        case password
        case confirmPassword
    }

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            AppConstants.Signup.backgroundColor
                .opacity(AppConstants.Signup.backgroundOpacity)
                .ignoresSafeArea()
            
            IconPatternView()
                .opacity(AppConstants.Signup.patternOpacity)
                .ignoresSafeArea()

            brandHeader
            
            VStack(spacing: AppConstants.Signup.rootStackSpacing) {
                
                Spacer().frame(height: AppConstants.Signup.topSpacerHeight)
                
                WaveShape()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .overlay(formSection)
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

@available(iOS 16.0, *)
extension SignupView {
    
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
            VStack(alignment: .leading, spacing: AppConstants.Signup.titleSpacing) {
                
                Text(AppConstants.Signup.title(for: language))
                    .font(.system(size: AppConstants.Signup.headerFontSize, weight: .bold))
                
                
                /// Name
                capsuleField(
                    icon: AppConstants.Signup.nameIcon,
                    placeholder: AppConstants.Signup.namePlaceholder(for: language),
                    text: $name
                )
                .focused($focusedField, equals: .name)
                
                
                /// Email
                capsuleField(
                    icon: AppConstants.Signup.emailIcon,
                    placeholder: AppConstants.Signup.emailPlaceholder(for: language),
                    text: $email
                )
                .focused($focusedField, equals: .email)
                
                
                /// Password
                secureCapsuleField(
                    icon: AppConstants.Signup.passwordIcon,
                    placeholder: AppConstants.Signup.passwordPlaceholder(for: language),
                    text: $password
                )
                .focused($focusedField, equals: .password)
                
                
                /// Confirm Password
                secureCapsuleField(
                    icon: AppConstants.Signup.confirmPasswordIcon,
                    placeholder: AppConstants.Signup.confirmPasswordPlaceholder(for: language),
                    text: $confirmPassword
                )
                .focused($focusedField, equals: .confirmPassword)
                
                
                /// Signup Button
                Button {
                    dismissKeyboard()
                    print(AppConstants.Signup.signupTappedLog)
                } label: {
                    
                    Text(AppConstants.Signup.createAccountTitle(for: language))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            formValid
                            ? AppConstants.Signup.backgroundColor
                            : AppConstants.Signup.backgroundColor.opacity(AppConstants.Signup.disabledButtonOpacity)
                        )
                        .cornerRadius(AppConstants.Signup.buttonCornerRadius)
                }
                .disabled(!formValid)
                .padding(.top, AppConstants.Signup.buttonTopPadding)
                
                
                /// Bottom Login Text
                HStack {
                    
                    Spacer()
                    
                    Text(AppConstants.Signup.alreadyHaveAccountTitle(for: language))
                        .foregroundColor(AppConstants.Signup.bottomTextColor)
                    
                    Text(AppConstants.Signup.signInTitle(for: language))
                        .foregroundColor(AppConstants.Signup.backgroundColor)
                        .fontWeight(.semibold)
                        .onTapGesture {
                            dismiss()
                        }
                    
                    Spacer()
                }
                .padding(.top, AppConstants.Signup.bottomSectionTopPadding)
            }
            .padding(.horizontal, AppConstants.Signup.formHorizontalPadding)
            .padding(.top, AppConstants.Signup.formTopPadding)
            .padding(.bottom, AppConstants.Signup.formTopPadding)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

@available(iOS 16.0, *)
extension SignupView {
    
    var formValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
}


// MARK: Capsule Field

@available(iOS 16.0, *)
extension SignupView {
    
    func capsuleField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        
        HStack {
            
            Image(systemName: icon)
                .foregroundColor(AppConstants.Signup.textFieldIconColor)
            
            TextField(placeholder, text: text)
                .autocapitalization(.none)
        }
        .padding()
        .background(
            Capsule().fill(Color.white)
        )
        .overlay(
            Capsule()
                .stroke(
                    AppConstants.Signup.fieldBorderColor.opacity(AppConstants.Signup.fieldBorderOpacity),
                    lineWidth: AppConstants.Signup.fieldBorderLineWidth
                )
        )
    }
    
    
    func secureCapsuleField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        
        HStack {
            
            Image(systemName: icon)
                .foregroundColor(AppConstants.Signup.textFieldIconColor)
            
            SecureField(placeholder, text: text)
        }
        .padding()
        .background(
            Capsule().fill(Color.white)
        )
        .overlay(
            Capsule()
                .stroke(
                    AppConstants.Signup.fieldBorderColor.opacity(AppConstants.Signup.fieldBorderOpacity),
                    lineWidth: AppConstants.Signup.fieldBorderLineWidth
                )
        )
    }
}


// MARK: Keyboard

@available(iOS 16.0, *)
extension SignupView {
    
    func dismissKeyboard() {
        focusedField = nil
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        SignupView()
    } else {
        EmptyView()
    }
}
