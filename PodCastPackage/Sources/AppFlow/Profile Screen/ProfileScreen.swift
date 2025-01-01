//
//  ProfileScreen.swift
//  PodCastPackage
//
//  Created by islam Awaad on 24/12/2024.
//

import SwiftUI
import NetworkHandling

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()

                Text("Abo Abdullah")
                    .font(.title)

                Text("Abo.Abdullah@example.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()

                Divider()

                List {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Image(systemName: "person.crop.edit")
                            Text("Edit Profile")
                        }
                    }

                    NavigationLink(destination: SettingsView(title: "VAT")) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("VAT")
                        }
                    }

                    NavigationLink(destination: SettingsView(title: "Terms and Conditions")) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Terms and Conditions")
                        }
                    }

                    NavigationLink(destination: SettingsView(title: "Change Language")) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Change Language")
                        }
                    }

                    Button(action: {
                        viewModel.dependencies.session.logout()
                    }) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left")
                            Text("Log Out")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct EditProfileView: View {
    var body: some View {
        Text("Edit Profile View")
            .navigationTitle("Edit Profile")
    }
}

struct SettingsView: View {
    var title: String

    var body: some View {
        Text(title)
            .navigationTitle(title)
    }
}

