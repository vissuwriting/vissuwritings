//
//  UserProfileView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct UserProfileView: View {
    private let name = "Satya"
    private let email = "satya.writings@gmail.com"
    @State private var selectedLanguage = "English"
    private let languages = ["English", "Telugu"]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 86))
                        .foregroundColor(Color(hex: "#7B8FA8"))

                    Text(name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(hex: "#1E2A39"))

                    Text(email)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "#5B6472"))

                    HStack(spacing: 12) {
                        Text("Language")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#1E2A39"))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)

                        Spacer()

                        Picker("Language", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 220)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "#E2E8F0"), lineWidth: 1)
                    )
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            UserProfileView()
        }
    } else {
        EmptyView()
    }
}
