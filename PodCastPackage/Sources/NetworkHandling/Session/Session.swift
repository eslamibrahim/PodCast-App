//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import Combine
import WebKit

public enum LoginStatus {
    case loggedIn
    case loggedOut
}

public struct Session {
    private let keychain: Keychain
    private let defaults: UserDefaults
    
    public var loginStatus: AnyPublisher<LoginStatus, Never> {
        _loginStatus.eraseToAnyPublisher()
    }
    
    private let _loginStatus = PassthroughSubject<LoginStatus, Never>()
    
    init(
        keychain: Keychain,
        defaults: UserDefaults,
        client: Client
    ) {
        self.keychain = keychain
        self.defaults = defaults
    }
    
    public var isLoggedIn: Bool {
        return  token != nil
    }
    
    public func save(token: String) {
        keychain.save(key: tokenKey, value: token)
        _loginStatus.send(.loggedIn)
    }
    
    public var token: String? { 
        return keychain.read(key: tokenKey) ?? readTokenFromDefaults()
    }
    
    
    public func logout() {
        let websiteDataTypes = WebKit.WKWebsiteDataStore.allWebsiteDataTypes()
        DispatchQueue.main.async {
            // must be called on main thread
            let datastore = WebKit.WKWebsiteDataStore.default()
            datastore.removeData(ofTypes: websiteDataTypes, modifiedSince: .init(timeIntervalSince1970: 0)) {}
        }
        keychain.delete(key: tokenKey)
        defaults.removeObject(forKey: tokenDefaultsKey)
        _loginStatus.send(.loggedOut)
    }
    
    func readTokenFromDefaults() -> String? {
        let dictionary = defaults.dictionary(forKey: tokenDefaultsKey)
        return dictionary?["access_token"] as? String
    }
}

struct JWTTokenResponse: Decodable {
    let token: String
    let tokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case tokenType = "token_type"
    }
}

public extension Session {
    static let live = Session(
        keychain: .live,
        defaults: UserDefaults.standard,
        client: .live
    )
    
    static func mock(
        defaults: UserDefaults = UserDefaults.standard,
        client: Client = .mock()
    ) -> Session {
        Session(
            keychain: .mock,
            defaults: defaults,
            client: client
        )
    }
}

let tokenKey = "token"
let tokenDefaultsKey = "AuthToken"
let userKey = "userKey"
