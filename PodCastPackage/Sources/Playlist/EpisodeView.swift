//
//  TransactionView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import UI
import AVKit

struct EpisodeView: View {
    let episode: Episode
    @State var openPlayer = false
    var body: some View {
        VStack {
            Divider()
            HStack(spacing: 16) {
                FillImage(episode.image)
                    .frame(width: 76, height: 76)
                    .cornerRadius(8, corners: .allCorners)
                
                VStack(alignment: .leading,spacing: 2) {
                    Text(episode.name ?? "")
                        .lineLimit(2)
                        .font(.semiBoldName)
                    Text(episode.podcastName ?? "")
                        .font(.RegularSmallText)
                        .foregroundColor(Color.black.opacity(0.4))
                    Text(episode.releaseDateArabicString )
                        .font(.RegularSmallText)
                        .foregroundColor(Color.black.opacity(0.4))
                }
                Spacer()
                HStack {
                    Button(action: {
                        openPlayer.toggle()
                    }, label: {
                        Image("Play")
                    })
                    Button(action: {}, label: {
                        Image("menu")
                    })
                }
            }
            Divider()
            Spacer()
        }
        .sheet(isPresented: $openPlayer, content: {
            AVPlayerView(videoURL: episode.audioLink)
        })
        .padding(.horizontal)
    }
}
