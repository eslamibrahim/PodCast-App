//
//  AdminHome.swift
//  PodCastPackage
//
//  Created by islam Awaad on 25/12/2024.
//

import SwiftUI

struct AdminHomeListView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
                List(viewModel.state.list ?? [], id: \.requestID) { item in
                    NavigationLink(destination: RequestDetailsView(viewModel: .init(dependencies: viewModel.dependencies, id: item.requestDetailsID))) {
                        HStack(spacing: 15) {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .shadow(color: .gray, radius: 3, x: 1, y: 2)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.englishName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Request Support Level: \(item.supportLevel.description)")
                                    .font(.subheadline)
                                Text("Request Support Type: \(item.supportType.description)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(8)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(12)
                        .animation(.spring())
                    }
//                    .buttonStyle(PlainButtonStyle())
                }
                .navigationTitle("Requests List")
                .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
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
            }
        }
        .onAppear {
            Task{ await viewModel.loadRequestsList() } 
        }
    }
    
    func getTextColor(for SupportType: SupportEnums.SupportTypeEnum,
                      SupportLevel: SupportEnums.SupportLevelEnum) -> Color {
        
        switch SupportLevel {
        case .Low:
            return .gray
        case .Medium:
            return .red
        case .High:
            return .green
        case .Critical:
            return .red
        }
    }
}

struct DetailView: View {
    
    
    var body: some View {
        EmptyView()
    }
}

