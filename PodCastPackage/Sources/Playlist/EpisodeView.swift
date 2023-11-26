//
//  TransactionView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import UI

struct EpisodeView: View {
    let episode: Episode
    
    var body: some View {
        VStack {
            Divider()
            HStack(spacing: 16) {
                FillImage(episode.image)
                    .frame(width: 76, height: 76)
                    .cornerRadius(8, corners: .allCorners)
                
                VStack(alignment: .leading) {
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
            }
            .font(.RegularSmallText)
            Divider()
            Spacer()
        }
        .padding(.horizontal)
    }
}
