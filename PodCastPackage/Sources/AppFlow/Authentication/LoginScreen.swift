//
//  File.swift
//
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import SwiftUI
import Lottie

struct LoginView: View {

    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
            VStack {

                LottieView {
                    LottieAnimation.named("login")?.animationSource
                } placeholder: {
                    Text("Loading...")
                }
                .playing(loopMode: .loop)
                .reloadAnimationTrigger("login", showPlaceholder: true)
                .animationSpeed(0.4)
                
                TextField("Username", text: $viewModel.state.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $viewModel.state.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Perform login logic here
                    Task {await viewModel.login()}
                    
                }) {
                    Text("Log in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .disabled(viewModel.state.isLoginDisabled)
                .padding()
                
                if case .loading = viewModel.state.state {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
        }
    }
    
}
