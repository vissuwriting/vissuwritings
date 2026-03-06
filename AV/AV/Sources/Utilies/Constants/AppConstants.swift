//
//  AppConstants.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

enum AppConstants {
    enum Dashboard {
        static let homeTitle = "Home Screen"
        static let homeTitleFont = Font.largeTitle

        static let homeTabIcon = "house.fill"
        static let searchTabIcon = "magnifyingglass"
        static let alertsTabIcon = "bell.fill"
        static let profileTabIcon = "person.crop.circle"

        static let homeTabTitle = "Home"
        static let searchTabTitle = "Search"
        static let alertsTabTitle = "Alerts"
        static let profileTabTitle = "Profile"
    }

    enum IconPattern {
        static let icons = [
            "book.closed",
            "pencil",
            "music.note",
            "doc.text",
            "mic",
            "quote.bubble",
            "note.text"
        ]

        static let columns = 5
        static let rows = 6

        static let cellHeight: CGFloat = 90
        static let iconFontSize: CGFloat = 42
        static let iconForegroundOpacity = 0.95
        static let rotationMin = -20.0
        static let rotationMax = 20.0
        static let verticalOffset: CGFloat = 40
    }

    enum Signin {
        static let title = "Sign in"
        static let emailPlaceholder = "Enter your Name"
        static let passwordPlaceholder = "Enter your password"
        static let loginTitle = "Login"
        static let forgotPasswordTitle = "Forgot Password?"
        static let noAccountTitle = "Don't have an Account?"
        static let signUpTitle = "Sign up"

        static let emailIcon = "person"
        static let passwordIcon = "lock"

        static let backgroundColor = Color(red: 0.94, green: 0.42, blue: 0.40)
        static let foregroundOnAccentColor = Color.white
        static let fieldBackgroundColor = Color.white
        static let waveFillColor = Color.white
        static let textFieldIconColor = Color.gray
        static let bottomTextColor = Color.gray
        static let accentColor = Color.red
        static let fieldBorderColor = Color.red

        static let backgroundOpacity = 0.8
        static let patternOpacity = 0.10
        static let disabledButtonOpacity = 0.3
        static let fieldBorderOpacity = 0.7

        static let headerFontSize: CGFloat = 32
        static let forgotPasswordFontSize: CGFloat = 14
        static let formSpacing: CGFloat = 25
        static let rootStackSpacing: CGFloat = 0
        static let topSpacerHeight: CGFloat = 240
        static let buttonCornerRadius: CGFloat = 14
        static let buttonTopPadding: CGFloat = -5
        static let bottomSectionTopPadding: CGFloat = 5
        static let formHorizontalPadding: CGFloat = 35
        static let formTopPadding: CGFloat = 80
        static let fieldBorderLineWidth: CGFloat = 1
    }

    enum Signup {
        static let title = "Sign Up"
        static let namePlaceholder = "Enter your Name"
        static let emailPlaceholder = "Enter your Email"
        static let passwordPlaceholder = "Enter Password"
        static let confirmPasswordPlaceholder = "Confirm Password"
        static let createAccountTitle = "Create Account"
        static let alreadyHaveAccountTitle = "Already have an account?"
        static let signInTitle = "Sign in"
        static let signupTappedLog = "Signup tapped"

        static let nameIcon = "person"
        static let emailIcon = "envelope"
        static let passwordIcon = "lock"
        static let confirmPasswordIcon = "lock.fill"

        static let backgroundColor = Color(red: 0.94, green: 0.42, blue: 0.40)
        static let textFieldIconColor = Color.gray
        static let bottomTextColor = Color.gray
        static let fieldBorderColor = Color.red

        static let backgroundOpacity = 0.8
        static let patternOpacity = 0.10
        static let disabledButtonOpacity = 0.3
        static let fieldBorderOpacity = 0.7

        static let headerFontSize: CGFloat = 32
        static let titleSpacing: CGFloat = 22
        static let topSpacerHeight: CGFloat = 100
        static let buttonTopPadding: CGFloat = 5
        static let bottomSectionTopPadding: CGFloat = 10
        static let formHorizontalPadding: CGFloat = 35
        static let formTopPadding: CGFloat = 85
        static let buttonCornerRadius: CGFloat = 14
        static let rootStackSpacing: CGFloat = 0
        static let fieldBorderLineWidth: CGFloat = 1
    }
}

