//
//  AdminHome.swift
//  PodCastPackage
//
//  Created by islam Awaad on 25/12/2024.
//

import SwiftUI

struct AdminHomeListView: View {
    @StateObject var viewModel: HomeViewModel
    var itemOnPressed: (Int,Int) -> Void
    
    var body: some View {
        VStack {
            if viewModel.dependencies.session.user?.role == .Admin {
                NavigationLink {
                    FormView(viewModel: .init(dependencies: viewModel.dependencies))
                } label: {
                    Text("Add Request")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            switch viewModel.state.state {
            case .loading,.idle, .error:
                ProgressView()
            case .success(let list):
                
                List(list, id: \.requestID) { item in
                    Section {
                        VStack(alignment: .leading) {
                            Text(item.englishName)
                                .bold()
                                .font(.title2)
                            Divider()
                            
                            HStack(spacing: 15) {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Support Level: ")
                                            .font(.subheadline)
                                        
                                        Text("\(item.supportLevel.description)")
                                            .font(.subheadline)
                                            .bold()
                                    }
                                    HStack {
                                        Text("Support Type: ")
                                            .font(.subheadline)
                                        
                                        Text("\(item.supportType.description)")
                                            .font(.subheadline)
                                            .bold()
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        itemOnPressed(item.requestDetailsID, item.requestID)
                    }
       
                }
                .navigationTitle("Requests List")
                .navigationBarTitleDisplayMode(.inline)
            }
   
        }
        .onAppear {
            Task{ await viewModel.loadRequestsList() } 
        }
    }
    
}
