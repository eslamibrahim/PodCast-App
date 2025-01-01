//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import NetworkHandling
import Combine

class LoginViewModel: ObservableObject {
    
    let loginLoader: LoginLoader
    let dependencies : SessionDependencies
    @Published var state = Status()
    init(dependencies : SessionDependencies) {
        self.dependencies = dependencies
        self.loginLoader = .init(client: dependencies.client, session: dependencies.session)
    }
    
    @MainActor func login() async {
        state.state = .loading
        do {
            try await loginLoader.login(email: state.username, password: state.password)
            state.state = .success
        }
        catch {
            state.state = .error(error.localizedDescription)
        }
    }
    
//    GaserAdmin    123456
//    MohamedSupervisor    123456
//    AboFahdWorkerManager    123456
//    KhanWorker    123456
    struct Status: Hashable {
        
        var state: Status.State = .idle
        var username: String = "MohamedSupervisor"
        var password: String = "123456"
        
        enum State: Hashable {
            case loading
            case success
            case error(String)
            case idle
        }
        
        var isLoginDisabled: Bool {
            username.isEmpty && password.isEmpty
        }
    }
    
}
