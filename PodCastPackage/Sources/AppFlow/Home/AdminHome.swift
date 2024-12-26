//
//  AdminHome.swift
//  PodCastPackage
//
//  Created by islam Awaad on 25/12/2024.
//

import SwiftUI

struct HomeListItem: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var requestState: String
    var imageName: String
}

struct HomeListView: View {
    @StateObject var viewModel: HomeViewModel

    let items: [HomeListItem] = [
        HomeListItem(title: "Item 1", description: "Description for Item 1", requestState: "Pending", imageName: "item1_image"),
        HomeListItem(title: "Item 2", description: "Description for Item 2", requestState: "Approved", imageName: "item2_image"),
        HomeListItem(title: "Item 3", description: "Description for Item 3", requestState: "Rejected", imageName: "item3_image")
    ]

    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: DetailView(item: item)) {
                    HStack(spacing: 15) {
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                            .shadow(color: .gray, radius: 3, x: 1, y: 2)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(.gray)
                            Text("Request State: \(item.requestState)")
                                .font(.subheadline)
                                .foregroundColor(getTextColor(for: item.requestState))
                        }
                    }
                    .padding(12)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(12)
                    .padding(.vertical, 5)
                    .animation(.spring())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Home List")
        }
    }

    func getTextColor(for requestState: String) -> Color {
        switch requestState {
        case "Pending":
            return Color.orange
        case "Approved":
            return Color.green
        case "Rejected":
            return Color.red
        default:
            return Color.black
        }
    }
}

struct DetailView: View {
    var item: HomeListItem

    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .cornerRadius(12)
                .shadow(color: .gray, radius: 3, x: 1, y: 2)

            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)

            Text(item.description)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 5)
        }
        .padding()
        .navigationTitle(item.title)
    }
}

