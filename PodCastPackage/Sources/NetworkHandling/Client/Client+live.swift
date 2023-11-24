//
//  File.swift
//  
//
//  Created by Naif Alrashed on 13/09/2022.
//

import Foundation
import AsyncCompatibilityKit

public extension Client {
    static let live: Client = Client(client: session.request(for:))
}
