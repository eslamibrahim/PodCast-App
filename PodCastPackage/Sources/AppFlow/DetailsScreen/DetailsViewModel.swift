//
//  DetailsViewModel.swift
//  PodCastPackage
//
//  Created by islam Awaad on 28/12/2024.
//


import Foundation
import NetworkHandling
import Combine

class DetailsViewModel: ObservableObject {
    
    let detailsLoader: DetailsLoader
    let dependencies : SessionDependencies
    var id: Int
    @Published var state = Status()
    init(dependencies : SessionDependencies,
         id: Int) {
        self.dependencies = dependencies
        self.id = id
        self.detailsLoader = .init(client: dependencies.client, session: dependencies.session)
        Task { await loadRequest() }
    }
    
    @MainActor func loadRequest() async {
        state.state = .loading
        do {
            var item: RequestDetails!
            if let user = dependencies.session.user {
                switch user.role {
                case .Admin:
                    item = try await detailsLoader.loadAdminRequestDetails(id: id)
                case .SuperVisor:
                    item = try await detailsLoader.loadSupervisorRequestDetails(id: id)
                case .WorkerManager:
                    item = try await detailsLoader.loadWorkerManagerRequestDetails(id: id)
                case .Worker:
                    item = try await detailsLoader.loadWorkerRequestDetails(id: id)
                }
            }
            state.state = .success(item)
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
            case success(RequestDetails)
            case error(String)
            case idle
        }
        
        var  requestDetails: RequestDetails? {
            if case .success(let item) = state {
                return item
            }
            return nil
        }

    }
    
}
