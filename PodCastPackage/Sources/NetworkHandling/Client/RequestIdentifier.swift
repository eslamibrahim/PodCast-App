//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

public struct RequestIdentifier {
    let path: String
}

extension RequestIdentifier: Hashable {
    public static func containing(path: String) -> Self {
        RequestIdentifier(path: path)
    }
}

extension RequestIdentifier {
    func isMatching(request: URLRequest) -> Bool {
        return (request.url?.path ?? "").contains(path)
    }
}
