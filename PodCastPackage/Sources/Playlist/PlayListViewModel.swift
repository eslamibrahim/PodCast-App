//
//  File.swift
//  
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation
import NetworkHandling
import Combine

class PlayListViewModel: ObservableObject {
    
    let playlistLoader: PlaylistLoader
    let dependencies : SessionDependencies
    @Published var state = Status()
    init(dependencies : SessionDependencies) {
        self.dependencies = dependencies
        self.playlistLoader = .init(client: dependencies.client, session: dependencies.session)
    }
    
    @MainActor func loadPlayList() async {
        state.state = .loading
        do {
            let playlist = try await playlistLoader.loadPlayList()
            state.state = .success(playlist)
        }
        catch {
            state.state = .error(error.localizedDescription)
        }
    }
    
    
    struct Status: Hashable {
        
        var state: Status.State = .idle
        
        enum State: Hashable {
            case loading
            case success(PlayListResponse)
            case error(String)
            case idle
        }
        
        var  playlist: Playlist? {
            if case .success(let playListResponse) = state {
                return playListResponse.data.playlist
            }
            return nil
        }
        
        var episodes: [Episode] {
            if case .success(let playListResponse) = state {
                return playListResponse.data.episodes
            }
            return []
        }
    }
    
}
