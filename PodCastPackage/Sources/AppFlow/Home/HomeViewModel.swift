//
//  File.swift
//  
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation
import NetworkHandling
import Combine

class HomeViewModel: ObservableObject {
    
    let homeLoader: HomeLoader
    let dependencies : SessionDependencies
    @Published var state = Status()
    init(dependencies : SessionDependencies) {
        self.dependencies = dependencies
        self.homeLoader = .init(client: dependencies.client, session: dependencies.session)
    }
    
    @MainActor func loadRequestsList() async {
        state.state = .loading
        do {
            var list: [RequestElement] = []
            if let user = dependencies.session.user {
                switch user.role {
                case .Admin:
                    list = try await homeLoader.loadAdminRequestsList()
                case .SuperVisor:
                    list = try await homeLoader.loadSupervisorRequestsList()
                case .WorkerManager:
                    list = try await homeLoader.loadWorkerManagerRequestsList()
                case .Worker:
                    list = try await homeLoader.loadWorkerRequestsList()
                }
            }
            state.state = .success(list)
        }
        catch {
            state.state = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    
    struct Status: Hashable {
        
        var state: Status.State = .idle
        
        enum State: Hashable {
            case loading
            case success([RequestElement])
            case error(String)
            case idle
        }
        
        var  list: [RequestElement]? {
            if case .success(let listResponse) = state {
                return listResponse
            }
            return nil
        }

    }
    
}
