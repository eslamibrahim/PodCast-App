//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

public enum Method: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public extension URLRequest {
    init(
        url: String = "https://staging.podcast.kaitdev.com/client/",
        method: Method = .get,
        path: String,
        queryItems: [String: String] = [:],
        body: Data? = nil,
        headers headersSet: Set<Header> = [
            .contentTypeJson,
        ],
        timeout: TimeInterval = 30,
        session: Session = .live
    ) {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = queryItems.map { keyValuePair in
            URLQueryItem(name: keyValuePair.key, value: keyValuePair.value)
        }

        var url = urlComponents?.url
        url?.appendPathComponent(path)

        self.init(url: url!)
        timeoutInterval = timeout
        httpMethod = method.rawValue
        httpBody = body
        allHTTPHeaderFields = headersSet.toDictionary(session: session)
    }
    
    init(
        url: URL?,
        method: Method = .get,
        body: Data? = nil,
        headers headersSet: Set<Header> = [
            .contentTypeJson,
        ],
        timeout: TimeInterval = 30,
        session: Session = .live
    ) {
        self.init(url: url!)
        timeoutInterval = timeout
        httpMethod = method.rawValue
        httpBody = body
        allHTTPHeaderFields = headersSet.toDictionary(session: session)
    }
}

public enum Header: Hashable {
    /// will try to retrieve the token, then pass it to the header like this
    /// Authorization: Bearer THE_TOKEN
    case authorization
    /// sets "Content-Type": "application/json"
    case contentTypeJson
    /// sets "Content-Type": "application/x-www-form-urlencoded"
    case contentTypeURLFormEncoded

    case custom(key: String, value: String)
}

extension Set where Element == Header {
    public func toDictionary(session: Session) -> [String: String] {
        var dictionary: [String: String] = [:]
        forEach { element in
            switch element {
            case .authorization:
                if let token = session.token {
                    dictionary["Authorization"] = "Bearer \(token)"
                }
            case .contentTypeJson:
                dictionary["Content-Type"] = "application/json"
            case .contentTypeURLFormEncoded:
                dictionary["Content-Type"] = "application/x-www-form-urlencoded"
            case .custom(let key, let value):
                dictionary[key] = value
            }
        }
        return dictionary
    }
}
