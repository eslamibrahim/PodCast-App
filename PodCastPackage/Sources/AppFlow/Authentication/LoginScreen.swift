//
//  File.swift
//
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import SwiftUI


struct LoginView: View {

    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("background")
                    .resizable()
                
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                
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
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(viewModel.state.isLoginDisabled)
                .padding()
                
                if case .loading = viewModel.state.state {
                    ProgressView()
                        .padding()
                }
            }
        }
    }
    
}
