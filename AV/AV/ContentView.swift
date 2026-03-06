//
//  ContentView.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var email: String = "demo@email.com"
    @State private var password: String = ""
    @State private var remember: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {

            Color(red: 0.94, green: 0.42, blue: 0.40)
                .ignoresSafeArea()

            IconPatternView()
                .opacity(0.10)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 240)

                WaveShape()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .overlay(formSection)
            }
        }
    }
}

extension ContentView {
    
    var formSection: some View {
        
        VStack(alignment: .leading, spacing: 25) {
            
            Text("Sign in")
                .font(.system(size: 32, weight: .bold))
            
            // Email
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Email")
                    .foregroundColor(.gray)
                
                TextField("", text: $email)
                    .foregroundColor(.blue)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 1)
            }
            
            // Password
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Password")
                    .foregroundColor(.gray)
                
                SecureField("enter your password", text: $password)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 1)
            }
            
            // Remember + Forgot
            HStack {
                
                Button {
                    remember.toggle()
                } label: {
                    
                    HStack(spacing: 6) {
                        
                        Image(systemName: remember ? "checkmark.square.fill" : "square")
                            .foregroundColor(.red)
                        
                        Text("Remember Me")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    }
                }
                
                Spacer()
                
                Text("Forgot Password?")
                    .foregroundColor(.red)
                    .font(.system(size: 14))
            }
            
            // Login Button
            Button {
                
            } label: {
                
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.94, green: 0.42, blue: 0.40))
                    .cornerRadius(14)
            }
            .padding(.top, 10)
            
            // Bottom Text
            HStack {
                Spacer()
                
                Text("Don't have an Account?")
                    .foregroundColor(.gray)
                
                Text("Sign up")
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding(.top, 30)
            
            Spacer()
        }
        .padding(.horizontal, 35)
        .padding(.top, 70)
    }
}

struct WaveShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 65))
        
        path.addCurve(
            to: CGPoint(x: rect.width, y: 120),
            control1: CGPoint(x: rect.width * 0.25, y: 20),
            control2: CGPoint(x: rect.width * 0.75, y: 180)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    ContentView()
}


struct IconPatternView: View {
    
    let icons = [
        "book.closed",
        "pencil",
        "music.note",
        "doc.text",
        "mic",
        "quote.bubble",
        "note.text"
    ]
    
    let columns = 5
    let rows = 6
    
    var body: some View {
        
        GeometryReader { geo in
            
            let cellWidth = geo.size.width / CGFloat(columns)
            let cellHeight: CGFloat = 90
            
            ZStack {
                
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { col in
                        
                        Image(systemName: icons[(row + col) % icons.count])
                            .font(.system(size: 42))
                            .foregroundColor(.white.opacity(0.95))
                            .rotationEffect(.degrees(Double.random(in: -20...20)))
                            .position(
                                x: cellWidth * CGFloat(col) + cellWidth / 2,
                                y: cellHeight * CGFloat(row) + 40
                            )
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
