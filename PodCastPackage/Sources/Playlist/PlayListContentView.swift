//
//  ProfileScreen.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import UI
struct PlayListContentView: View {
    

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PlayListViewModel
    @State var progress: CGFloat = 0
    private let minHeight = 110.0
    private let maxHeight = 372.0
    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                    largeHeader(progress: progress)
            } content: {
                Color.white.frame(height: 15)
                ForEach(viewModel.state.episodes, id: \.id) { episode in
                    EpisodeView(episode: episode)
                }
                Color.white.frame(height: 15)
                Spacer()
            }
            .height(min: minHeight, max: maxHeight)
            .collapseProgress($progress)
            .allowsHeaderGrowth()
            
          topButtons
        }
        .ignoresSafeArea(edges: .top)
    }

    private var topButtons: some View {
        VStack {
            HStack {
                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                    .padding(.leading, 17)
                    .padding(.top, 50)
                Spacer()
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis"))
                    .padding(.trailing, 17)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    private var smallHeader: some View {
        VStack(spacing: 12.0) {
            FillImage(viewModel.state.playlist?.image)
                .frame(height: minHeight)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))

            Text("kkdk kwkdmksdod")
                
        }
    }
    
    private func largeHeader(progress: CGFloat) -> some View {
        ZStack {
            FillImage(viewModel.state.playlist?.image)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300,height: maxHeight)
                .opacity(1 - progress)
            
            VStack(alignment: .leading) {
                Spacer()
                VStack (spacing: 16, content: {
                    Text(viewModel.state.playlist?.name ?? "")
                        .font(.semiBoldLargeTitle)
                    
                    Text(viewModel.state.playlist?.description ?? "")
                        .font(.RegularTitle)
                })
                .padding()
                .opacity(1 - progress)

                
                ZStack() {
                    smallHeader
                        .opacity(progress)
                        .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                }
                .frame(height: 80.0)
            }
        }
    }
    

}

