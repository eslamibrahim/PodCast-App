//
//  File.swift
//
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import SwiftUI
import UI

struct PlaylistScreenView: View {
    
    @ObservedObject var viewModel: PlayListViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state.state {
            case .loading:
                ProgressView()
            case .success(_):
                PlayListContentView(viewModel: viewModel)
            case .error(let error):
                Spacer()
            case .idle:
                Spacer()
            }
        }
        .onViewDidLoad {
            Task{ await viewModel.loadPlayList()}
        }
    }
    
}

