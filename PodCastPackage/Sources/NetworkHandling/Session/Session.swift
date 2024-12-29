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
    
    public var user: AuthResponse? {
        let userObject = defaults.object(forKey: userObjectKey) as! String
        if let decodedPerson: AuthResponse = jsonStringToObject(userObject, type: AuthResponse.self) {
            return decodedPerson
        }
        return nil
    }
    
    public func save(user: AuthResponse) {
        keychain.save(key: tokenKey, value: "\(user.userID)")
        saveUserData(user: user)
        _loginStatus.send(.loggedIn)
    }
    
    func saveUserData(user: AuthResponse) {
        if let jsonString = objectToJSONString(user) {
            defaults.set(jsonString, forKey: userObjectKey)
        }
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
let userObjectKey = "userObjectKey"


public struct AuthResponse: Codable {
    public let userID: Int
    public let englishName, arabicName, userLocationName: String
    public  let userLocationMapLink: String
    public let userEmail, userMobileNumber: String
    public let latitude, longitude: Double
    public let address: String
    public let role: RoleEnum

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case englishName, arabicName, userLocationName, userLocationMapLink, userEmail, userMobileNumber, latitude, longitude, address, role
    }
}

public enum RoleEnum: Int, Codable {
    case Admin = 1
    case SuperVisor
    case WorkerManager
    case Worker
}


// Convert object to JSON string
func objectToJSONString<T: Encodable>(_ object: T) -> String? {
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(object)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error encoding object to JSON: \(error.localizedDescription)")
    }
    return nil
}

// Convert JSON string to object
func jsonStringToObject<T: Decodable>(_ jsonString: String, type: T.Type) -> T? {
    if let jsonData = jsonString.data(using: .utf8) {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: jsonData)
            return object
        } catch {
            print("Error decoding JSON string to object: \(error.localizedDescription)")
        }
    }
    return nil
}
