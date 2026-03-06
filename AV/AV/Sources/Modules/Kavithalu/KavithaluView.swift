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
                            kavithaCard(item)
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
        HStack(alignment: .top, spacing: 12) {
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
            .frame(width: 112, height: 112)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A39"))
                
                Text(item.preview)
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#EDF2F8"), lineWidth: 1)
        )
    }
}

private struct KavithaItem: Identifiable, Decodable {
    var id: String { "\(title)" }
    let title: String
    let preview: String
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
            preview: "Nee akkada chupina navvu naa hrudayam lo inka alaage undi...",
            likes: 234,
            category: "Nature"
        ),
        .init(
            title: "Mabbuloni Velugu",
            preview: "Poddune velugu laanti maatallo jeevitham ki kottha sneham...",
            likes: 512,
            category: "Patriotic"
        ),
        .init(
            title: "Varsham Paata",
            preview: "Gaalilo paata, varshamlo maataki artham kanipinche samayam...",
            likes: 189,
            category: "Seasons"
        ),
        .init(
            title: "Prema Kadha",
            preview: "Cheyi pattukoni nadiche daari lo prema maatalu marichipovu...",
            likes: 678,
            category: "Love"
        )
    ]
}
