//
//  ContentView.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {

                Color(red: 0.94, green: 0.42, blue: 0.40).opacity(0.8)
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
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
}

@available(iOS 16.0, *)
extension ContentView {
    
    var formSection: some View {
        
        VStack(alignment: .leading, spacing: 25) {
            
            Text("Sign in")
                .font(.system(size: 32, weight: .bold))
            
            
            /// Email Field
            HStack {
                
                Image(systemName: "person")
                    .foregroundColor(.gray)
                
                TextField("Enter your Name", text: $email)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
            }
            .padding()
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .overlay(
                Capsule()
                    .stroke(Color.red.opacity(0.7), lineWidth: 1)
            )
            
            
            /// Password Field
            HStack {
                
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                
                SecureField("Enter your password", text: $password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    .onSubmit {
                        dismissKeyboard()
                    }
            }
            .padding()
            .background(
                Capsule()
                    .fill(Color.white)
            )
            .overlay(
                Capsule()
                    .stroke(Color.red.opacity(0.7), lineWidth: 1)
            )
            
            
            /// Forgot Password (Only when typing password)
            if focusedField == .password {
                
                HStack {
                    Spacer()
                    
                    Text("Forgot Password?")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                .transition(.opacity)
            }
            
            
            /// Login Button
            Button {
                dismissKeyboard()
                print("Login tapped")
            } label: {
                
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        (email.isEmpty || password.isEmpty)
                        ? Color(red: 0.94, green: 0.42, blue: 0.40).opacity(0.3)
                        : Color(red: 0.94, green: 0.42, blue: 0.40)
                    )
                    .cornerRadius(14)
            }
            .disabled(email.isEmpty || password.isEmpty)
            .padding(.top, -5)
            
            
            /// Bottom Text
            /// Bottom Text
            HStack {
                Spacer()
                
                Text("Don't have an Account?")
                    .foregroundColor(.gray)
                
                NavigationLink(destination: SignupView()) {
                    Text("Sign up")
                        .foregroundColor(.red)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .padding(.top, 5)
            
            Spacer()
        }
        .padding(.horizontal, 35)
        .padding(.top, 80)
    }
}


// MARK: - Keyboard Dismiss

@available(iOS 16.0, *)
extension ContentView {
    
    func dismissKeyboard() {
        focusedField = nil
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
    if #available(iOS 16.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
    }
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



import SwiftUI

@available(iOS 16.0, *)
struct SignupView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    enum Field {
        case name
        case email
        case password
        case confirmPassword
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color(red: 0.94, green: 0.42, blue: 0.40).opacity(0.8)
                .ignoresSafeArea()
            
            IconPatternView()
                .opacity(0.10)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Spacer().frame(height: 220)
                
                WaveShape()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .overlay(formSection)
            }
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}

@available(iOS 16.0, *)
extension SignupView {
    
    var formSection: some View {
        
        VStack(alignment: .leading, spacing: 22) {
            
            Text("Sign Up")
                .font(.system(size: 32, weight: .bold))
            
            
            /// Name
            capsuleField(
                icon: "person",
                placeholder: "Enter your Name",
                text: $name
            )
            .focused($focusedField, equals: .name)
            
            
            /// Email
            capsuleField(
                icon: "envelope",
                placeholder: "Enter your Email",
                text: $email
            )
            .focused($focusedField, equals: .email)
            
            
            /// Password
            secureCapsuleField(
                icon: "lock",
                placeholder: "Enter Password",
                text: $password
            )
            .focused($focusedField, equals: .password)
            
            
            /// Confirm Password
            secureCapsuleField(
                icon: "lock.fill",
                placeholder: "Confirm Password",
                text: $confirmPassword
            )
            .focused($focusedField, equals: .confirmPassword)
            
            
            /// Signup Button
            Button {
                dismissKeyboard()
                print("Signup tapped")
            } label: {
                
                Text("Create Account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        formValid
                        ? Color(red: 0.94, green: 0.42, blue: 0.40)
                        : Color(red: 0.94, green: 0.42, blue: 0.40).opacity(0.3)
                    )
                    .cornerRadius(14)
            }
            .disabled(!formValid)
            .padding(.top, 5)
            
            
            /// Bottom Login Text
            HStack {
                
                Spacer()
                
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Text("Sign in")
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 35)
        .padding(.top, 70)
    }
}

@available(iOS 16.0, *)
extension SignupView {
    
    var formValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }
}


// MARK: Capsule Field

@available(iOS 16.0, *)
extension SignupView {
    
    func capsuleField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        
        HStack {
            
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            TextField(placeholder, text: text)
                .autocapitalization(.none)
        }
        .padding()
        .background(
            Capsule().fill(Color.white)
        )
        .overlay(
            Capsule()
                .stroke(Color.red.opacity(0.7), lineWidth: 1)
        )
    }
    
    
    func secureCapsuleField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        
        HStack {
            
            Image(systemName: icon)
                .foregroundColor(.gray)
            
            SecureField(placeholder, text: text)
        }
        .padding()
        .background(
            Capsule().fill(Color.white)
        )
        .overlay(
            Capsule()
                .stroke(Color.red.opacity(0.7), lineWidth: 1)
        )
    }
}


// MARK: Keyboard

@available(iOS 16.0, *)
extension SignupView {
    
    func dismissKeyboard() {
        focusedField = nil
    }
}
