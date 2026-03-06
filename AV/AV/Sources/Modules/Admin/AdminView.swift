//
//  AdminView.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murtyk on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct AdminView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    
                    Text("Admin Screen")
                        .font(.largeTitle)
                    
                    Button("Logout") {
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}
