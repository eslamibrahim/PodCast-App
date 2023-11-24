//
//  File.swift
//  
//
//  Created by Naif Alrashed on 13/09/2022.
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
