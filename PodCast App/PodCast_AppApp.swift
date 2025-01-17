//
//  PodCast_AppApp.swift
//  PodCast App
//
//  Created by islam Awaad on 24/11/2023.
//

import SwiftUI
import AppFlow
@main
@available(iOS 18.0, *)
struct PodCast_AppApp: App {
    var body: some Scene {
        WindowGroup {
            RootAppFlowView()
                .ignoresSafeArea(.all)
                .preferredColorScheme(.light)
        }
    }
}
