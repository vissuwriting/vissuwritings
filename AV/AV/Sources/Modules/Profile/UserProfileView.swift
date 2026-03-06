//
//  UserProfileView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct UserProfileView: View {
    private let name = "Vissu"
    private let email = "vissu.writings@gmail.com"
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 86))
                    .foregroundColor(Color(hex: "#7B8FA8"))

                Text(name)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color(hex: "#1E2A39"))

                Text(email)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "#5B6472"))
            }
            .padding(24)
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
