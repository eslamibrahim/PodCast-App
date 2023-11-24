//
//  PodCast_AppApp.swift
//  PodCast App
//
//  Created by islam Awaad on 24/11/2023.
//

import SwiftUI

@main
struct PodCast_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
