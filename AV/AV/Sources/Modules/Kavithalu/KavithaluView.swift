//
//  KavithaluView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct KavithaluView: View {
    
    @State private var kavithalu: [KavithaItem] = KavithaItem.fallback
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        ForEach(kavithalu) { item in
                            NavigationLink {
                                KavithaDetailView(item: item)
                            } label: {
                                kavithaCard(item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                }
            }
        }
        .onAppear {
            kavithalu = KavithaItem.loadFromBundle(named: "kavithalu")
        }
    }
    
    private func kavithaCard(_ item: KavithaItem) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: item.style.topColorHex), Color(hex: item.style.bottomColorHex)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                Image(systemName: item.style.symbol)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 112)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A39"))
                
                Text(item.kavithaPreview)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#5B6472"))
                    .lineLimit(2)
                    .padding(.top, 2)
                
                HStack {
                    Label("\(item.likes)", systemImage: "heart")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#E56B7A"))
                    
                    Spacer()
                    
                    Text(item.category)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#66A7DF"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#E8F2FC"))
                        .clipShape(Capsule())
                }
                .padding(.top, 3)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 122)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#EDF2F8"), lineWidth: 1)
        )
    }
}

private struct KavithaItem: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let fullKavitha: String
    let likes: Int
    let category: String
    
    var style: KavithaStyle {
        switch category.lowercased() {
        case "nature":
            return .init(symbol: "cloud.sun.fill", topColorHex: "#6EC6FF", bottomColorHex: "#2E7D32")
        case "patriotic":
            return .init(symbol: "sunrise.fill", topColorHex: "#90CAF9", bottomColorHex: "#43A047")
        case "seasons":
            return .init(symbol: "cloud.rain.fill", topColorHex: "#90A4AE", bottomColorHex: "#546E7A")
        case "love":
            return .init(symbol: "heart.fill", topColorHex: "#F8BBD0", bottomColorHex: "#6D4C41")
        default:
            return .init(symbol: "book.fill", topColorHex: "#A5D6A7", bottomColorHex: "#607D8B")
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
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let items = try? JSONDecoder().decode([KavithaItem].self, from: data),
            !items.isEmpty
        else {
            return fallback
        }
        return items
    }

    static let fallback: [KavithaItem] = [
        .init(
            title: "Nee Aakasham",
            fullKavitha: "Nee akkada chupina navvu naa hrudayam lo inka alaage undi. Gaalilo tirige pratibimbam laaga nee gurtulu prati saayantram tirigi vastunnayi. Prati varsham boondalo nee maata vintunna anipistundi.",
            likes: 234,
            category: "Nature"
        ),
        .init(
            title: "Mabbuloni Velugu",
            fullKavitha: "Poddune velugu laanti maatallo jeevitham ki kottha sneham. Mabbullo kuda kanipinche velugu laaga manchi alochanalu manasuni prakaashistayi. Oka sari navvite prapancham motham kotha rangullo merustundi.",
            likes: 512,
            category: "Patriotic"
        ),
        .init(
            title: "Varsham Paata",
            fullKavitha: "Gaalilo paata, varshamlo maataki artham kanipinche samayam idi. Meghalu padina prathi chota bhoomi kotha gundello palukuthundi. Ee raatri tholakari paata lo prematho kalisina jnapakalu unnayi.",
            likes: 189,
            category: "Seasons"
        ),
        .init(
            title: "Prema Kadha",
            fullKavitha: "Cheyi pattukoni nadiche daari lo prema maatalu marichipovu. Oka chinna choopu lo pedda prapancham untundi. Kalisi navvina kshanalu kalam daggara nilichipoye gnapakalu avuthayi.",
            likes: 678,
            category: "Love"
        )
    ]
}

@available(iOS 16.0, *)
private struct KavithaDetailView: View {
    let item: KavithaItem

    private var readingMinutes: Int {
        max(1, (item.fullKavitha.split(separator: " ").count + 119) / 120)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    LinearGradient(
                        colors: [Color(hex: item.style.topColorHex), Color(hex: item.style.bottomColorHex)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: item.style.symbol)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white.opacity(0.95))
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(item.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A39"))

                Text("By Vissu")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#5B8FCB"))

                HStack(spacing: 10) {
                    Label("\(item.likes)", systemImage: "heart.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#E56B7A"))

                    Text(item.category)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#66A7DF"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(hex: "#E8F2FC"))
                        .clipShape(Capsule())

                    Text("\(readingMinutes) min read")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#728096"))
                }

                Text(item.fullKavitha)
                    .font(.system(size: 17))
                    .foregroundColor(Color(hex: "#334155"))
                    .lineSpacing(6)
            }
            .padding(16)
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension KavithaItem {
    var kavithaPreview: String {
        let trimmed = fullKavitha.trimmingCharacters(in: .whitespacesAndNewlines)
        if let firstSentence = trimmed.split(separator: ".").first, !firstSentence.isEmpty {
            return firstSentence + "..."
        }
        let limit = 78
        if trimmed.count > limit {
            let end = trimmed.index(trimmed.startIndex, offsetBy: limit)
            return String(trimmed[..<end]) + "..."
        }
        return trimmed
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        KavithaluView()
    } else {
        EmptyView()
    }
}
