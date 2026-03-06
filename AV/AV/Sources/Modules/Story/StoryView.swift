//
//  StoryView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct StoryView: View {
    @AppStorage(AppConstants.languageStorageKey) private var selectedLanguage = AppLanguage.english.rawValue
    @State private var stories: [StoryItem] = []
    @State private var selectedCategory = AppConstants.Story.defaultCategory
    @State private var selectedStory: StoryItem?
    @State private var isStoryActive = false
    @State private var isFilterSwitching = false
    @State private var cardTapBlockedUntil: Date = .distantPast

    private var language: AppLanguage {
        AppLanguage.from(selectedLanguage)
    }

    private var filteredStories: [StoryItem] {
        if selectedCategory == AppConstants.Story.categoryAll {
            return stories
        }
        return stories.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppConstants.Story.listSpacing) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(AppConstants.Story.categories, id: \.self) { category in
                                    categoryChip(category)
                                }
                            }
                            .padding(.horizontal, AppConstants.Story.rootHorizontalPadding)
                        }

                        if filteredStories.isEmpty {
                            Text(AppConstants.Story.emptyText(language))
                                .foregroundColor(Color(hex: "#6B7280"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, AppConstants.Story.rootHorizontalPadding)
                        } else {
                            ForEach(filteredStories) { story in
                                storyCard(story)
                                    .contentShape(RoundedRectangle(cornerRadius: AppConstants.Story.cardCornerRadius))
                                    .onTapGesture {
                                        guard Date() >= cardTapBlockedUntil else { return }
                                        selectedStory = story
                                        isStoryActive = true
                                    }
                                    .disabled(isFilterSwitching)
                            }
                        }
                    }
                    .padding(.horizontal, AppConstants.Story.rootHorizontalPadding)
                    .padding(.vertical, AppConstants.Story.rootVerticalPadding)
                }
            }
            .background(
                NavigationLink(isActive: $isStoryActive) {
                    if let story = selectedStory {
                        StoryDetailView(story: story, language: language) .tabBarHidden()
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
            stories = StoryItem.loadFromBundle(named: AppConstants.Story.jsonFileName)
        }
    }

    private func categoryChip(_ category: String) -> some View {
        let selected = selectedCategory == category
        return Button {
            guard selectedCategory != category else { return }
            isFilterSwitching = true
            cardTapBlockedUntil = Date().addingTimeInterval(0.6)
            selectedCategory = category
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                isFilterSwitching = false
            }
        } label: {
            Text(AppConstants.Story.categoryLabel(category, language))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "#4B5563"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selected ? Color(hex: "#E8ECF1") : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#D6DCE5"), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func storyCard(_ story: StoryItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            StoryCardImage(urlString: story.imageURL)
                .frame(height: AppConstants.Story.cardImageHeight)

            VStack(alignment: .leading, spacing: 0) {
                Text(story.title(for: language))
                    .font(.system(size: AppConstants.Story.titleSize, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: AppConstants.Story.titleHex))
                    .padding(.top, 8)

                Text(story.summary(for: language))
                    .font(.system(size: AppConstants.Story.summarySize))
                    .foregroundColor(Color(hex: AppConstants.Story.summaryHex))
                    .lineLimit(2)
                    .padding(.top, AppConstants.Story.summaryTopPadding)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppConstants.Story.contentPadding)
            .background(.white)
        }
        .background(Color(hex: AppConstants.Story.cardBackgroundHex))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Story.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Story.cardCornerRadius)
                .stroke(Color(hex: AppConstants.Story.cardBorderHex), lineWidth: AppConstants.Story.cardBorderWidth)
        )
    }
}

private struct StoryCardImage: View {
    let urlString: String

    var body: some View {
        Group {
            if let url = URL(string: urlString), !urlString.isEmpty {
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
        .clipped()
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: AppConstants.Story.imageFallbackTopHex),
                    Color(hex: AppConstants.Story.imageFallbackBottomHex)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            Image(systemName: AppConstants.Story.imageFallbackSymbol)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

private struct StoryItem: Identifiable, Decodable, Hashable {
    let id = UUID()
    let title: String
    let titleTelugu: String?
    let author: String
    let authorTelugu: String?
    let summary: String
    let summaryTelugu: String?
    let fullStory: String
    let fullStoryTelugu: String?
    let category: String
    let readMinutes: Int
    let imageURL: String

    func title(for language: AppLanguage) -> String {
        if language == .telugu, let titleTelugu, !titleTelugu.isEmpty { return titleTelugu }
        return title
    }

    func author(for language: AppLanguage) -> String {
        if language == .telugu, let authorTelugu, !authorTelugu.isEmpty { return authorTelugu }
        return author
    }

    func summary(for language: AppLanguage) -> String {
        if language == .telugu, let summaryTelugu, !summaryTelugu.isEmpty { return summaryTelugu }
        return summary
    }

    func body(for language: AppLanguage) -> String {
        if language == .telugu, let fullStoryTelugu, !fullStoryTelugu.isEmpty { return fullStoryTelugu }
        return fullStory
    }
}

private extension StoryItem {
    static func loadFromBundle(named fileName: String) -> [StoryItem] {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: AppConstants.Story.jsonFileExtension),
            let data = try? Data(contentsOf: url),
            let items = try? JSONDecoder().decode([StoryItem].self, from: data)
        else {
            return []
        }
        return items
    }
}

@available(iOS 16.0, *)
private struct StoryDetailView: View {
    let story: StoryItem
    let language: AppLanguage

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppConstants.Story.detailSpacing) {
                StoryCardImage(urlString: story.imageURL)
                    .frame(height: 230)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(story.title(for: language))
                    .font(.system(size: AppConstants.Story.detailTitleSize, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: AppConstants.Story.titleHex))

                HStack {
                    Text(AppConstants.Story.byAuthor(language))
                        .font(.system(size: AppConstants.Story.authorSize, weight: .semibold))
                        .foregroundColor(Color(hex: AppConstants.Story.authorHex))

                    Spacer()

                    Label(
                        AppConstants.Story.readMinutesText(story.readMinutes, language),
                        systemImage: AppConstants.Story.clockIcon
                    )
                    .font(.system(size: AppConstants.Story.readTimeSize, weight: .medium))
                    .foregroundColor(Color(hex: AppConstants.Story.readTimeHex))
                }

                Text(story.body(for: language))
                    .font(.system(size: AppConstants.Story.detailBodySize))
                    .foregroundColor(Color(hex: AppConstants.Story.summaryHex))
                    .lineSpacing(6)
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        StoryView()
    } else {
        EmptyView()
    }
}
