//
//  AppConstants.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case telugu = "Telugu"

    static func from(_ rawValue: String) -> AppLanguage {
        if let exact = AppLanguage(rawValue: rawValue) {
            return exact
        }

        let normalized = rawValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch normalized {
        case "english", "en", "ఇంగ్లీష్":
            return .english
        case "telugu", "te", "తెలుగు":
            return .telugu
        default:
            return .english
        }
    }

    func displayName(for interfaceLanguage: AppLanguage) -> String {
        switch (self, interfaceLanguage) {
        case (.english, .telugu): return "ఇంగ్లీష్"
        case (.telugu, .telugu): return "తెలుగు"
        case (.english, .english): return "English"
        case (.telugu, .english): return "Telugu"
        }
    }
}

enum AppConstants {
    static let languageStorageKey = "selectedLanguage"

    enum Kavithalu {
        static let jsonFileName = "kavithalu"
        static let defaultSelectedCategory = Category.all
        static let initialPositiveTip = ""
        static let categoryKeys = [Category.all, Category.nature, Category.love, Category.patriotic, Category.seasons]
        static let positiveTipsEnglish = [
            "Your writing has power. Keep going.",
            "One good thought can change your whole day.",
            "Small progress in writing is still big progress.",
            "Your voice matters. Share it with confidence.",
            "Create from the heart and let it flow."
        ]
        static let positiveTipsTelugu = [
            "మీ రచనలో బలం ఉంది. అలాగే ముందుకు వెళ్లండి.",
            "ఒక మంచి ఆలోచన మీ రోజును మార్చగలదు.",
            "చిన్న పురోగతి కూడా పెద్ద విజయం.",
            "మీ స్వరం ముఖ్యం. ధైర్యంగా పంచుకోండి.",
            "హృదయం నుంచి రాయండి, ప్రవాహంలా సాగండి."
        ]

        static let emptyStateMessagePrefix = "No related kavithalu in "
        static let emptyStateMessageSuffix = "."
        static let greetingTitleEnglish = "Good Evening...!"
        static let greetingTitleTelugu = "శుభ సాయంత్రం...!"
        static let authorLabelEnglish = "By Vissu"
        static let authorLabelTelugu = "రచన: విస్సు"
        static let minReadSuffixEnglish = "min read"
        static let minReadSuffixTelugu = "నిమిషాల చదువు"
        static let jsonFileExtension = "json"
        static let sentenceSeparator: Character = "."
        static let ellipsis = "..."

        static let avatarSymbol = "person.fill"
        static let likesSymbol = "heart"
        static let detailLikesSymbol = "heart.fill"

        static let zeroSpacing: CGFloat = 0
        static let rootSpacing: CGFloat = 14
        static let horizontalChipSpacing: CGFloat = 10
        static let rootHorizontalPadding: CGFloat = 12
        static let rootTopPadding: CGFloat = 10
        static let rootBottomPadding: CGFloat = 16
        static let greetingHorizontalPadding: CGFloat = 14
        static let greetingVerticalPadding: CGFloat = 10
        static let greetingCornerRadius: CGFloat = 14
        static let chipCornerRadius: CGFloat = 10
        static let chipHorizontalPadding: CGFloat = 16
        static let chipVerticalPadding: CGFloat = 8
        static let chipBorderWidth: CGFloat = 1
        static let cardHeight: CGFloat = 122
        static let cardCornerRadius: CGFloat = 16
        static let cardStrokeWidth: CGFloat = 1
        static let cardImageWidth: CGFloat = 112
        static let cardContentSpacing: CGFloat = 4
        static let cardContentPadding: CGFloat = 12
        static let cardPreviewTopPadding: CGFloat = 2
        static let cardMetaTopPadding: CGFloat = 3
        static let cardPreviewLineLimit = 2
        static let categoryHorizontalPadding: CGFloat = 10
        static let categoryVerticalPadding: CGFloat = 4
        static let detailCategoryVerticalPadding: CGFloat = 5
        static let detailContainerPadding: CGFloat = 16
        static let detailSpacing: CGFloat = 16
        static let detailHeroHeight: CGFloat = 180
        static let detailHeroCornerRadius: CGFloat = 20
        static let detailMetaSpacing: CGFloat = 10
        static let detailLineSpacing: CGFloat = 6

        static let cardImageSymbolSize: CGFloat = 24
        static let cardTitleFontSize: CGFloat = 14
        static let cardPreviewFontSize: CGFloat = 14
        static let cardLikesFontSize: CGFloat = 14
        static let cardCategoryFontSize: CGFloat = 12
        static let chipFontSize: CGFloat = 14
        static let emptyStateFontSize: CGFloat = 14
        static let greetingTitleFontSize: CGFloat = 18
        static let greetingTipFontSize: CGFloat = 14
        static let avatarSize: CGFloat = 44
        static let avatarIconSize: CGFloat = 22
        static let avatarOpacity = 0.92
        static let detailHeroSymbolSize: CGFloat = 42
        static let detailHeroSymbolOpacity = 0.95
        static let cardImageSymbolOpacity = 0.9
        static let detailTitleFontSize: CGFloat = 26
        static let detailAuthorFontSize: CGFloat = 18
        static let detailMetaFontSize: CGFloat = 13
        static let detailLikesFontSize: CGFloat = 14
        static let detailBodyFontSize: CGFloat = 17

        static let cardTitleColorHex = "#1E2A39"
        static let cardPreviewColorHex = "#5B6472"
        static let likesColorHex = "#E56B7A"
        static let categoryTextColorHex = "#66A7DF"
        static let categoryBackgroundColorHex = "#E8F2FC"
        static let cardBorderColorHex = "#EDF2F8"
        static let chipTextColorHex = "#4B5563"
        static let chipSelectedColorHex = "#E8ECF1"
        static let chipBorderColorHex = "#D6DCE5"
        static let emptyStateColorHex = "#6B7280"
        static let greetingCardColorHex = "#E6EFEB"
        static let greetingAvatarColorHex = "#A9BEB2"
        static let greetingTitleColorHex = "#1E2A39"
        static let greetingTipColorHex = "#6C7A87"
        static let detailTitleColorHex = "#1E2A39"
        static let detailAuthorColorHex = "#5B8FCB"
        static let detailMetaColorHex = "#728096"
        static let detailBodyColorHex = "#334155"

        enum Category {
            static let all = "All"
            static let nature = "Nature"
            static let love = "Love"
            static let patriotic = "Patriotic"
            static let seasons = "Seasons"
        }

        enum Style {
            static let defaultSymbol = "book.fill"
            static let defaultTopColorHex = "#A5D6A7"
            static let defaultBottomColorHex = "#607D8B"

            static let natureSymbol = "cloud.sun.fill"
            static let natureTopColorHex = "#6EC6FF"
            static let natureBottomColorHex = "#2E7D32"

            static let patrioticSymbol = "sunrise.fill"
            static let patrioticTopColorHex = "#90CAF9"
            static let patrioticBottomColorHex = "#43A047"

            static let seasonsSymbol = "cloud.rain.fill"
            static let seasonsTopColorHex = "#90A4AE"
            static let seasonsBottomColorHex = "#546E7A"

            static let loveSymbol = "heart.fill"
            static let loveTopColorHex = "#F8BBD0"
            static let loveBottomColorHex = "#6D4C41"
        }

        static let previewTrimLimit = 78
        static let readingWordsPerMinute = 120
        static let minimumReadMinutes = 1
        static let readingRoundUpAdjustment = 1

        static func greetingTitle(for language: AppLanguage) -> String {
            language == .telugu ? greetingTitleTelugu : greetingTitleEnglish
        }

        static func authorLabel(for language: AppLanguage) -> String {
            language == .telugu ? authorLabelTelugu : authorLabelEnglish
        }

        static func minReadSuffix(for language: AppLanguage) -> String {
            language == .telugu ? minReadSuffixTelugu : minReadSuffixEnglish
        }

        static func positiveTips(for language: AppLanguage) -> [String] {
            language == .telugu ? positiveTipsTelugu : positiveTipsEnglish
        }

        static func emptyStateMessage(category: String, language: AppLanguage) -> String {
            if language == .telugu {
                return "\(category) లో సంబంధిత కవితలు లేవు."
            }
            return "No related kavithalu in \(category)."
        }

        static func categoryLabel(for key: String, language: AppLanguage) -> String {
            if language == .telugu {
                switch key {
                case Category.all: return "అన్నీ"
                case Category.nature: return "ప్రకృతి"
                case Category.love: return "ప్రేమ"
                case Category.patriotic: return "దేశభక్తి"
                case Category.seasons: return "ఋతువులు"
                default: return key
                }
            }
            return key
        }
    }

    enum Story {
        static let jsonFileName = "stories"
        static let jsonFileExtension = "json"

        static let defaultCategory = "All"
        static let categoryAll = "All"
        static let categoryMoral = "Moral"
        static let categoryLife = "Life"
        static let categoryInspiration = "Inspiration"
        static let categoryVillage = "Village"
        static let categories = [categoryAll, categoryMoral, categoryLife, categoryInspiration, categoryVillage]

        static let listSpacing: CGFloat = 14
        static let cardCornerRadius: CGFloat = 16
        static let cardBorderWidth: CGFloat = 1
        static let cardImageHeight: CGFloat = 150
        static let contentPadding: CGFloat = 14
        static let chipCornerRadius: CGFloat = 8
        static let chipHorizontalPadding: CGFloat = 8
        static let chipVerticalPadding: CGFloat = 4
        static let categoryChipSize: CGFloat = 12
        static let readTimeSize: CGFloat = 13
        static let titleSize: CGFloat = 17
        static let detailTitleSize: CGFloat = 32
        static let authorSize: CGFloat = 13
        static let summarySize: CGFloat = 15
        static let detailBodySize: CGFloat = 18
        static let readButtonSize: CGFloat = 18
        static let readButtonTopPadding: CGFloat = 6
        static let rootHorizontalPadding: CGFloat = 12
        static let rootVerticalPadding: CGFloat = 12
        static let categoryRowTopPadding: CGFloat = 2
        static let titleTopPadding: CGFloat = 4
        static let authorTopPadding: CGFloat = 2
        static let summaryTopPadding: CGFloat = 5
        static let detailSpacing: CGFloat = 16

        static let clockIcon = "clock"
        static let readIcon = "book.fill"
        static let imageFallbackSymbol = "photo"
        static let imageFallbackTopHex = "#A6C3D8"
        static let imageFallbackBottomHex = "#7FAE92"

        static let cardBackgroundHex = "#FFFFFF"
        static let cardBorderHex = "#E8EEF5"
        static let titleHex = "#1B2430"
        static let authorHex = "#4D8CC8"
        static let summaryHex = "#7A8698"
        static let readTimeHex = "#8C98AA"
        static let readActionHex = "#2F82D8"
        static let categoryBgHex = "#E8F7E8"
        static let categoryTextHex = "#59A26B"

        static func readStoryTitle(_ language: AppLanguage) -> String {
            language == .telugu ? "కథ చదవండి" : "Read Story"
        }

        static let fixedAuthorName = "Vissu"

        static func byAuthor(_ language: AppLanguage) -> String {
            language == .telugu ? "రచన: విస్సు" : fixedAuthorName
        }

        static func readMinutesText(_ minutes: Int, _ language: AppLanguage) -> String {
            language == .telugu ? "\(minutes) నిమిషాల చదువు" : "\(minutes) min read"
        }

        static func categoryLabel(_ key: String, _ language: AppLanguage) -> String {
            guard language == .telugu else { return key }
            switch key {
            case categoryAll: return "అన్నీ"
            case categoryMoral: return "నీతి"
            case categoryLife: return "జీవితం"
            case categoryInspiration: return "ప్రేరణ"
            case categoryVillage: return "పల్లె"
            default: return key
            }
        }

        static func emptyText(_ language: AppLanguage) -> String {
            language == .telugu ? "ఈ విభాగంలో కథలు లేవు." : "No stories in this category."
        }
    }

    enum Songs {
        static let jsonFileName = "songs"
        static let jsonFileExtension = "json"

        static let featuredTitleEnglish = "Featured Playlist"
        static let featuredTitleTelugu = "ప్రధాన ప్లేలిస్ట్"
        static let featuredSubtitleEnglish = "Best of Telugu Songs"
        static let featuredSubtitleTelugu = "అత్యుత్తమ తెలుగు పాటలు"
        static let sectionTitleEnglish = "All Songs"
        static let sectionTitleTelugu = "అన్ని పాటలు"
        static let nowPlayingPrefixEnglish = "Now Playing:"
        static let nowPlayingPrefixTelugu = "ఇప్పుడు వినిపిస్తున్నది:"
        static let noSongSelectedEnglish = "No song selected"
        static let noSongSelectedTelugu = "ఏ పాట ఎంచుకోలేదు"
        static let playTitleEnglish = "Play"
        static let playTitleTelugu = "ప్లే"
        static let pauseTitleEnglish = "Pause"
        static let pauseTitleTelugu = "పాజ్"
        static let stopTitleEnglish = "Stop"
        static let stopTitleTelugu = "ఆపు"

        static let featuredImageURL = "https://picsum.photos/id/119/1200/500"
        static let bannerHeight: CGFloat = 180
        static let bannerCornerRadius: CGFloat = 18
        static let listRowImageSize: CGFloat = 56
        static let listRowCornerRadius: CGFloat = 10
        static let listSpacing: CGFloat = 12
        static let rootHorizontalPadding: CGFloat = 12
        static let sectionTopPadding: CGFloat = 8
        static let controlsTopPadding: CGFloat = 8
        static let controlsBottomPadding: CGFloat = 12
        static let previewDurationSeconds: Double = 10

        static let playIcon = "play.fill"
        static let pauseIcon = "pause.fill"
        static let stopIcon = "stop.fill"
        static let headphonesIcon = "headphones"
        static let defaultArtTopHex = "#7A5D4A"
        static let defaultArtBottomHex = "#2E3A50"
        static let accentHex = "#2F82D8"
        static let cardBorderHex = "#E5EAF1"
        static let subtleHex = "#8A96A8"

        static func featuredTitle(_ language: AppLanguage) -> String {
            language == .telugu ? featuredTitleTelugu : featuredTitleEnglish
        }

        static func featuredSubtitle(_ language: AppLanguage) -> String {
            language == .telugu ? featuredSubtitleTelugu : featuredSubtitleEnglish
        }

        static func sectionTitle(_ language: AppLanguage) -> String {
            language == .telugu ? sectionTitleTelugu : sectionTitleEnglish
        }

        static func playTitle(_ language: AppLanguage) -> String {
            language == .telugu ? playTitleTelugu : playTitleEnglish
        }

        static func pauseTitle(_ language: AppLanguage) -> String {
            language == .telugu ? pauseTitleTelugu : pauseTitleEnglish
        }

        static func stopTitle(_ language: AppLanguage) -> String {
            language == .telugu ? stopTitleTelugu : stopTitleEnglish
        }

        static func nowPlayingText(songTitle: String?, language: AppLanguage) -> String {
            if let songTitle, !songTitle.isEmpty {
                return "\(language == .telugu ? nowPlayingPrefixTelugu : nowPlayingPrefixEnglish) \(songTitle)"
            }
            return language == .telugu ? noSongSelectedTelugu : noSongSelectedEnglish
        }
    }

    enum Brand {
        static let primaryTitle = "Vissu"
        static let secondaryTitle = "Sahithi"
        static let headerIcon = "pencil.and.scribble"
        static let accentIcon = "scribble"

        static let topPadding: CGFloat = 56
        static let titleSpacing: CGFloat = -8
        static let contentSpacing: CGFloat = 10
        static let primaryFontSize: CGFloat = 32
        static let secondaryFontSize: CGFloat = 28
        static let secondaryKerning: CGFloat = 1.6
        static let secondaryOffsetX: CGFloat = 25
        static let iconCircleSize: CGFloat = 64
        static let headerIconSize: CGFloat = 30
        static let accentIconSize: CGFloat = 13

        static let primaryTextColor = Color.white
        static let secondaryTextColor = Color.white.opacity(0.94)
        static let iconBackgroundColor = Color.white.opacity(0.2)
        static let iconColor = Color.white

        static let shadowColor = Color.black.opacity(0.18)
        static let shadowRadius: CGFloat = 8
        static let shadowYOffset: CGFloat = 3

        static func primaryTitle(for language: AppLanguage) -> String {
            language == .telugu ? "రచన: విస్సు" : primaryTitle
        }

        static func secondaryTitle(for language: AppLanguage) -> String {
            language == .telugu ? "రచనలు" : secondaryTitle
        }
    }

    enum Dashboard {
        static let kavithaluTitle = "Kavithalu"
        static let kavithaluTitleFont = Font.largeTitle

        static let kavithaluTabIcon = "book.pages.fill"
        static let storyTabIcon = "text.book.closed.fill"
        static let songsTabIcon = "music.note.list"
        static let adminTabIcon = "person.crop.circle.fill"

        static func kavithaluTabTitle(_ language: AppLanguage) -> String {
            language == .telugu ? "కవితలు" : "Kavithalu"
        }
        static func storyTabTitle(_ language: AppLanguage) -> String {
            language == .telugu ? "కథలు" : "Stories"
        }
        static func songsTabTitle(_ language: AppLanguage) -> String {
            language == .telugu ? "పాటలు" : "Songs"
        }
        static func adminTabTitle(_ language: AppLanguage) -> String {
            language == .telugu ? "అడ్మిన్" : "Admin"
        }
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
        static let fieldBorderOpacity = 0.4

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
        static let fieldBorderLineWidth: CGFloat = 0.8

        static func title(for language: AppLanguage) -> String {
            language == .telugu ? "సైన్ ఇన్" : title
        }

        static func emailPlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "మీ పేరు నమోదు చేయండి" : emailPlaceholder
        }

        static func passwordPlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "మీ పాస్‌వర్డ్ నమోదు చేయండి" : passwordPlaceholder
        }

        static func loginTitle(for language: AppLanguage) -> String {
            language == .telugu ? "లాగిన్" : loginTitle
        }

        static func forgotPasswordTitle(for language: AppLanguage) -> String {
            language == .telugu ? "పాస్‌వర్డ్ మర్చిపోయారా?" : forgotPasswordTitle
        }

        static func noAccountTitle(for language: AppLanguage) -> String {
            language == .telugu ? "ఖాతా లేదా?" : noAccountTitle
        }

        static func signUpTitle(for language: AppLanguage) -> String {
            language == .telugu ? "సైన్ అప్" : signUpTitle
        }
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
        static let fieldBorderOpacity = 0.4

        static let headerFontSize: CGFloat = 32
        static let titleSpacing: CGFloat = 22
        static let topSpacerHeight: CGFloat = 100
        static let buttonTopPadding: CGFloat = 5
        static let bottomSectionTopPadding: CGFloat = 10
        static let formHorizontalPadding: CGFloat = 35
        static let formTopPadding: CGFloat = 85
        static let buttonCornerRadius: CGFloat = 14
        static let rootStackSpacing: CGFloat = 0
        static let fieldBorderLineWidth: CGFloat = 0.5

        static func title(for language: AppLanguage) -> String {
            language == .telugu ? "సైన్ అప్" : title
        }

        static func namePlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "మీ పేరు నమోదు చేయండి" : namePlaceholder
        }

        static func emailPlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "మీ ఇమెయిల్ నమోదు చేయండి" : emailPlaceholder
        }

        static func passwordPlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "పాస్‌వర్డ్ నమోదు చేయండి" : passwordPlaceholder
        }

        static func confirmPasswordPlaceholder(for language: AppLanguage) -> String {
            language == .telugu ? "పాస్‌వర్డ్ నిర్ధారించండి" : confirmPasswordPlaceholder
        }

        static func createAccountTitle(for language: AppLanguage) -> String {
            language == .telugu ? "ఖాతా సృష్టించండి" : createAccountTitle
        }

        static func alreadyHaveAccountTitle(for language: AppLanguage) -> String {
            language == .telugu ? "ఇప్పటికే ఖాతా ఉందా?" : alreadyHaveAccountTitle
        }

        static func signInTitle(for language: AppLanguage) -> String {
            language == .telugu ? "సైన్ ఇన్" : signInTitle
        }
    }
}
