//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import KeychainAccess

struct Keychain {
    private let save: (String, String) -> Void
    private let read: (String) -> String?
    private let delete: (String) -> Void
    
    init(
        save: @escaping (String, String) -> Void,
        read: @escaping (String) -> String?,
        delete: @escaping (String) -> Void
    ) {
        self.save = save
        self.read = read
        self.delete = delete
    }
    
    func save(key: String, value: String) {
        save(key, value)
    }
    
    func read(key: String) -> String? {
        read(key)
    }
    
    func delete(key: String) {
        delete(key)
    }
}

extension Keychain {
    static let live: Keychain = {
        let keychain = KeychainAccess.Keychain()
        return Keychain { key, value in
            keychain[key] = value
        } read: { key in
            keychain[key]
        } delete: { key in
            keychain[key] = nil
        }
    }()
    
    static let mock: Keychain = {
        var keychain: [String: String] = [:]
        return Keychain { key, value in
            keychain[key] = value
        } read: { key in
            keychain[key]
        } delete: { key in
            keychain[key] = nil
        }
    }()
}
