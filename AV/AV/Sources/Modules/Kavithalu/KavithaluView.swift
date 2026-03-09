//
//  KavithaluView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct KavithaluView: View {
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguageRaw = AppLanguage.english.rawValue
    @AppStorage(AppConstants.editModeStorageKey) private var isEditModeEnabled = false

    @State private var kavithalu: [KavithaItem] = []
    @State private var selectedCategoryKey: String = AppConstants.Kavithalu.defaultSelectedCategory
    @State private var positiveTip: String = AppConstants.Kavithalu.initialPositiveTip
    @State private var selectedKavitha: KavithaItem?
    @State private var isDetailActive = false
    @State private var likedKavithaIDs: Set<UUID> = []
    @State private var likedCounts: [UUID: Int] = [:]

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguageRaw)
    }

    @available(iOS 16.0, *)
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if filteredKavithalu.isEmpty {
                    VStack(spacing: AppConstants.Kavithalu.rootSpacing) {
                        greetingsView
                            .padding(.horizontal, AppConstants.Kavithalu.rootHorizontalPadding)
                            .padding(.top, AppConstants.Kavithalu.rootTopPadding)

                        emptyStateView
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: AppConstants.Kavithalu.rootSpacing) {
                            greetingsView

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppConstants.Kavithalu.horizontalChipSpacing) {
                                    ForEach(AppConstants.Kavithalu.categoryKeys, id: \.self) { key in
                                        categoryChip(key)
                                    }
                                }
                                .padding(.horizontal, AppConstants.Kavithalu.rootHorizontalPadding)
                            }

                            ForEach(filteredKavithalu) { item in
                                ZStack(alignment: .topTrailing) {
                                    kavithaCard(item)
                                        .contentShape(RoundedRectangle(cornerRadius: AppConstants.Kavithalu.cardCornerRadius))
                                        .onTapGesture {
                                            guard !isEditModeEnabled else { return }
                                            selectedKavitha = item
                                            isDetailActive = true
                                        }

                                    if isEditModeEnabled {
                                        deleteIconButton {
                                            deleteKavitha(item)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppConstants.Kavithalu.rootHorizontalPadding)
                        .padding(.top, AppConstants.Kavithalu.rootTopPadding)
                        .padding(.bottom, AppConstants.Kavithalu.rootBottomPadding)
                    }
                }
            }
            .background(
                NavigationLink(isActive: $isDetailActive) {
                    if let item = selectedKavitha {
                        KavithaDetailView(item: item, language: language) .tabBarHidden()
                    } else {
                        EmptyView()
                    }
                } label: {
                    EmptyView()
                }
                .hidden()
            )
        }
        .onAppear {
            kavithalu = KavithaItem.loadFromBundle(named: AppConstants.Kavithalu.jsonFileName)
            positiveTip = AppConstants.Kavithalu.positiveTips(for: language).randomElement() ?? positiveTip
        }
        .onChange(of: selectedLanguageRaw) { _ in
            positiveTip = AppConstants.Kavithalu.positiveTips(for: language).randomElement() ?? positiveTip
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#E8ECF1"))
                    .frame(width: 80, height: 80)

                Image(systemName: "text.book.closed")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.emptyStateColorHex))
            }

            Text(AppConstants.genericEmptyText(language))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: AppConstants.Kavithalu.emptyStateColorHex))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var greetingsView: some View {
        HStack(spacing: AppConstants.Kavithalu.cardContentPadding) {
            NavigationLink {
                UserProfileView() .tabBarHidden()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: AppConstants.Kavithalu.greetingAvatarColorHex))
                        .frame(width: AppConstants.Kavithalu.avatarSize, height: AppConstants.Kavithalu.avatarSize)

                    Image(systemName: AppConstants.Kavithalu.avatarSymbol)
                        .font(.system(size: AppConstants.Kavithalu.avatarIconSize, weight: .semibold))
                        .foregroundColor(.white.opacity(AppConstants.Kavithalu.avatarOpacity))
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: AppConstants.Kavithalu.cardContentSpacing) {
                Text(AppConstants.Kavithalu.greetingTitle(for: language))
                    .font(.system(size: AppConstants.Kavithalu.greetingTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.greetingTitleColorHex))

                Text(positiveTip)
                    .font(.system(size: AppConstants.Kavithalu.greetingTipFontSize, weight: .medium))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.greetingTipColorHex))
            }

            Spacer()
        }
        .padding(.horizontal, AppConstants.Kavithalu.greetingHorizontalPadding)
        .padding(.vertical, AppConstants.Kavithalu.greetingVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.Kavithalu.greetingCornerRadius)
                .fill(Color(hex: AppConstants.Kavithalu.greetingCardColorHex))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Kavithalu.greetingCornerRadius)
                .stroke(Color(hex: AppConstants.Kavithalu.greetingBorderColorHex), lineWidth: AppConstants.Kavithalu.greetingBorderWidth)
        )
    }

    private var filteredKavithalu: [KavithaItem] {
        if selectedCategoryKey == AppConstants.Kavithalu.Category.all {
            return kavithalu
        }
        return kavithalu.filter { $0.categoryKey == selectedCategoryKey }
    }

    private func categoryChip(_ key: String) -> some View {
        let selected = selectedCategoryKey == key
        let label = AppConstants.Kavithalu.categoryLabel(for: key, language: language)

        return Button {
            selectedCategoryKey = key
        } label: {
            Text(label)
                .font(.system(size: AppConstants.Kavithalu.chipFontSize, weight: .medium))
                .foregroundColor(Color(hex: AppConstants.Kavithalu.chipTextColorHex))
                .padding(.horizontal, AppConstants.Kavithalu.chipHorizontalPadding)
                .padding(.vertical, AppConstants.Kavithalu.chipVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: AppConstants.Kavithalu.chipCornerRadius)
                        .fill(selected ? Color(hex: AppConstants.Kavithalu.chipSelectedColorHex) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.Kavithalu.chipCornerRadius)
                        .stroke(Color(hex: AppConstants.Kavithalu.chipBorderColorHex), lineWidth: AppConstants.Kavithalu.chipBorderWidth)
                )
        }
        .buttonStyle(.plain)
    }

    private func kavithaCard(_ item: KavithaItem) -> some View {
        HStack(alignment: .top, spacing: AppConstants.Kavithalu.zeroSpacing) {
            KavithaPhotoView(item: item)
                .frame(
                    width: AppConstants.Kavithalu.cardImageWidth,
                    height: AppConstants.Kavithalu.cardHeight
                )
                .clipped()

            VStack(alignment: .leading, spacing: AppConstants.Kavithalu.cardContentSpacing) {
                Text(item.title(for: language))
                    .font(.system(size: AppConstants.Kavithalu.cardTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.cardTitleColorHex))

                Text(item.kavithaPreview(for: language))
                    .font(.system(size: AppConstants.Kavithalu.cardPreviewFontSize))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.cardPreviewColorHex))
                    .lineLimit(AppConstants.Kavithalu.cardPreviewLineLimit)
                    .padding(.top, AppConstants.Kavithalu.cardPreviewTopPadding)

                HStack {
                    Button {
                        toggleLike(for: item)
                    } label: {
                        Label("\(displayLikes(for: item))", systemImage: likeSymbol(for: item))
                            .font(.system(size: AppConstants.Kavithalu.cardLikesFontSize))
                            .foregroundColor(Color(hex: AppConstants.Kavithalu.likesColorHex))
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text(AppConstants.Kavithalu.categoryLabel(for: item.categoryKey, language: language))
                        .font(.system(size: AppConstants.Kavithalu.cardCategoryFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: AppConstants.Kavithalu.categoryTextColorHex))
                        .padding(.horizontal, AppConstants.Kavithalu.categoryHorizontalPadding)
                        .padding(.vertical, AppConstants.Kavithalu.categoryVerticalPadding)
                        .background(Color(hex: AppConstants.Kavithalu.categoryBackgroundColorHex))
                        .clipShape(Capsule())
                }
                .padding(.top, AppConstants.Kavithalu.cardMetaTopPadding)
            }
            .padding(AppConstants.Kavithalu.cardContentPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.white)
        }
        .frame(height: AppConstants.Kavithalu.cardHeight)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Kavithalu.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Kavithalu.cardCornerRadius)
                .stroke(Color(hex: AppConstants.Kavithalu.cardBorderColorHex), lineWidth: AppConstants.Kavithalu.cardStrokeWidth)
        )
    }

    private func displayLikes(for item: KavithaItem) -> Int {
        likedCounts[item.id] ?? item.likes
    }

    private func likeSymbol(for item: KavithaItem) -> String {
        likedKavithaIDs.contains(item.id) ? AppConstants.Kavithalu.detailLikesSymbol : AppConstants.Kavithalu.likesSymbol
    }

    private func toggleLike(for item: KavithaItem) {
        let currentlyLiked = likedKavithaIDs.contains(item.id)
        let currentCount = displayLikes(for: item)

        if currentlyLiked {
            likedKavithaIDs.remove(item.id)
            likedCounts[item.id] = max(0, currentCount - 1)
        } else {
            likedKavithaIDs.insert(item.id)
            likedCounts[item.id] = currentCount + 1
        }
    }

    private func deleteKavitha(_ item: KavithaItem) {
        kavithalu.removeAll { $0.id == item.id }
        likedKavithaIDs.remove(item.id)
        likedCounts[item.id] = nil
    }

    private func deleteIconButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "trash.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color.red)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(8)
    }
}

private struct KavithaItem: Identifiable, Decodable, Hashable {
    let id = UUID()
    let title: String
    let titleTelugu: String?
    let fullKavitha: String
    let fullKavithaTelugu: String?
    let likes: Int
    let category: String
    let imageURL: String?

    var categoryKey: String {
        let lower = category.lowercased()
        if lower == AppConstants.Kavithalu.Category.nature.lowercased() { return AppConstants.Kavithalu.Category.nature }
        if lower == AppConstants.Kavithalu.Category.love.lowercased() { return AppConstants.Kavithalu.Category.love }
        if lower == AppConstants.Kavithalu.Category.patriotic.lowercased() { return AppConstants.Kavithalu.Category.patriotic }
        if lower == AppConstants.Kavithalu.Category.seasons.lowercased() { return AppConstants.Kavithalu.Category.seasons }
        return AppConstants.Kavithalu.Category.all
    }

    var style: KavithaStyle {
        switch categoryKey {
        case AppConstants.Kavithalu.Category.nature:
            return .init(
                symbol: AppConstants.Kavithalu.Style.natureSymbol,
                topColorHex: AppConstants.Kavithalu.Style.natureTopColorHex,
                bottomColorHex: AppConstants.Kavithalu.Style.natureBottomColorHex
            )
        case AppConstants.Kavithalu.Category.patriotic:
            return .init(
                symbol: AppConstants.Kavithalu.Style.patrioticSymbol,
                topColorHex: AppConstants.Kavithalu.Style.patrioticTopColorHex,
                bottomColorHex: AppConstants.Kavithalu.Style.patrioticBottomColorHex
            )
        case AppConstants.Kavithalu.Category.seasons:
            return .init(
                symbol: AppConstants.Kavithalu.Style.seasonsSymbol,
                topColorHex: AppConstants.Kavithalu.Style.seasonsTopColorHex,
                bottomColorHex: AppConstants.Kavithalu.Style.seasonsBottomColorHex
            )
        case AppConstants.Kavithalu.Category.love:
            return .init(
                symbol: AppConstants.Kavithalu.Style.loveSymbol,
                topColorHex: AppConstants.Kavithalu.Style.loveTopColorHex,
                bottomColorHex: AppConstants.Kavithalu.Style.loveBottomColorHex
            )
        default:
            return .init(
                symbol: AppConstants.Kavithalu.Style.defaultSymbol,
                topColorHex: AppConstants.Kavithalu.Style.defaultTopColorHex,
                bottomColorHex: AppConstants.Kavithalu.Style.defaultBottomColorHex
            )
        }
    }

    func title(for language: AppLanguage) -> String {
        if language == .telugu, let titleTelugu, !titleTelugu.isEmpty {
            return titleTelugu
        }
        return title
    }

    func bodyText(for language: AppLanguage) -> String {
        if language == .telugu, let fullKavithaTelugu, !fullKavithaTelugu.isEmpty {
            return fullKavithaTelugu
        }
        return fullKavitha
    }

    var resolvedImageURL: String {
        if let imageURL, !imageURL.isEmpty {
            return imageURL
        }

        switch categoryKey {
        case AppConstants.Kavithalu.Category.nature:
            return "https://picsum.photos/id/1018/900/700"
        case AppConstants.Kavithalu.Category.patriotic:
            return "https://picsum.photos/id/1003/900/700"
        case AppConstants.Kavithalu.Category.seasons:
            return "https://picsum.photos/id/1011/900/700"
        case AppConstants.Kavithalu.Category.love:
            return "https://picsum.photos/id/1027/900/700"
        default:
            return "https://picsum.photos/id/1040/900/700"
        }
    }
}

private struct KavithaStyle {
    let symbol: String
    let topColorHex: String
    let bottomColorHex: String
}

private extension KavithaItem {
    static func loadFromBundle(named fileName: String) -> [KavithaItem] {
        guard
            let url = Bundle.main.url(
                forResource: fileName,
                withExtension: AppConstants.Kavithalu.jsonFileExtension
            ),
            let data = try? Data(contentsOf: url),
            let items = try? JSONDecoder().decode([KavithaItem].self, from: data),
            !items.isEmpty
        else {
            return []
        }
        return items
    }

    func kavithaPreview(for language: AppLanguage) -> String {
        let fullText = bodyText(for: language).trimmingCharacters(in: .whitespacesAndNewlines)
        if let firstSentence = fullText.split(separator: AppConstants.Kavithalu.sentenceSeparator).first, !firstSentence.isEmpty {
            return firstSentence + AppConstants.Kavithalu.ellipsis
        }
        let limit = AppConstants.Kavithalu.previewTrimLimit
        if fullText.count > limit {
            let end = fullText.index(fullText.startIndex, offsetBy: limit)
            return String(fullText[..<end]) + AppConstants.Kavithalu.ellipsis
        }
        return fullText
    }
}

@available(iOS 16.0, *)
private struct KavithaDetailView: View {
    let item: KavithaItem
    let language: AppLanguage

    private var readingMinutes: Int {
        let wordCount = item.bodyText(for: language).split(whereSeparator: \.isWhitespace).count
        return max(
            AppConstants.Kavithalu.minimumReadMinutes,
            (
                wordCount +
                (AppConstants.Kavithalu.readingWordsPerMinute - AppConstants.Kavithalu.readingRoundUpAdjustment)
            ) / AppConstants.Kavithalu.readingWordsPerMinute
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppConstants.Kavithalu.detailSpacing) {
                KavithaPhotoView(item: item)
                .frame(height: AppConstants.Kavithalu.detailHeroHeight)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Kavithalu.detailHeroCornerRadius))

                Text(item.title(for: language))
                    .font(.system(size: AppConstants.Kavithalu.detailTitleFontSize, weight: .bold))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.detailTitleColorHex))

                Text(AppConstants.Kavithalu.authorLabel(for: language))
                    .font(.system(size: AppConstants.Kavithalu.detailAuthorFontSize, weight: .semibold))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.detailAuthorColorHex))

                HStack(spacing: AppConstants.Kavithalu.detailMetaSpacing) {
                    Label("\(item.likes)", systemImage: AppConstants.Kavithalu.detailLikesSymbol)
                        .font(.system(size: AppConstants.Kavithalu.detailLikesFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: AppConstants.Kavithalu.likesColorHex))

                    Text(AppConstants.Kavithalu.categoryLabel(for: item.categoryKey, language: language))
                        .font(.system(size: AppConstants.Kavithalu.detailMetaFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: AppConstants.Kavithalu.categoryTextColorHex))
                        .padding(.horizontal, AppConstants.Kavithalu.categoryHorizontalPadding)
                        .padding(.vertical, AppConstants.Kavithalu.detailCategoryVerticalPadding)
                        .background(Color(hex: AppConstants.Kavithalu.categoryBackgroundColorHex))
                        .clipShape(Capsule())

                    Text("\(readingMinutes) \(AppConstants.Kavithalu.minReadSuffix(for: language))")
                        .font(.system(size: AppConstants.Kavithalu.detailMetaFontSize, weight: .medium))
                        .foregroundColor(Color(hex: AppConstants.Kavithalu.detailMetaColorHex))
                }

                Text(item.bodyText(for: language))
                    .font(.system(size: AppConstants.Kavithalu.detailBodyFontSize))
                    .foregroundColor(Color(hex: AppConstants.Kavithalu.detailBodyColorHex))
                    .lineSpacing(AppConstants.Kavithalu.detailLineSpacing)
            }
            .padding(AppConstants.Kavithalu.detailContainerPadding)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct KavithaPhotoView: View {
    let item: KavithaItem

    var body: some View {
        Group {
            if let url = URL(string: item.resolvedImageURL), !item.resolvedImageURL.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: item.style.topColorHex), Color(hex: item.style.bottomColorHex)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: item.style.symbol)
                .font(.system(size: AppConstants.Kavithalu.cardImageSymbolSize, weight: .semibold))
                .foregroundColor(.white.opacity(AppConstants.Kavithalu.cardImageSymbolOpacity))
        }
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        KavithaluView()
    } else {
        EmptyView()
    }
}
