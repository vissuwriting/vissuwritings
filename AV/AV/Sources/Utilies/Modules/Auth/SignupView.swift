//
//  SignupView.swift
//  AV
//
//  Created by Satvik on 06/03/26.
//

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
