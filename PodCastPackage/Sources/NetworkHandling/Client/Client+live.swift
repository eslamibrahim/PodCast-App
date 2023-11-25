//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import AsyncCompatibilityKit

public extension Client {
    static let live: Client = Client(client: session.request(for:))
}
