//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

public struct MockResponse {
    let data: Data
    let statusCode: Int
    let url: String
    let headers: [String: String]?
    let requestIdentifier: RequestIdentifier?
    let check: (URLRequest) -> Void
    
    var dataAndResponse: (Data, HTTPURLResponse) {
        (data, response)
    }
    
    var response: HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: url)!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers
        )!
    }
}

public extension MockResponse {
    /// create a response of the Data object
    /// - Parameters:
    ///   - data: the data that will be returned
    ///   - statusCode: the response status code for that request
    ///   - url: the response url
    ///   - headers: the response headers
    ///   - check: a closure used to validate the `URLRequest` for this request
    /// - Returns: a mock response
    static func data(
        _ data: Data = Data(),
        statusCode: Int = 200,
        url: String = "localhost",
        headers: [String: String]? = nil,
        forRequest requestIdentifier: RequestIdentifier? = nil,
        check: @escaping (URLRequest) -> Void = { _ in }
    ) -> MockResponse {
        MockResponse(
            data: data,
            statusCode: statusCode,
            url: url,
            headers: headers,
            requestIdentifier: requestIdentifier,
            check: check
        )
    }
    
    static func encodable<Response: Encodable>(
        _ encodable: Response,
        encoder: JSONEncoder = JSONEncoder(),
        statusCode: Int = 200,
        url: String = "localhost",
        headers: [String: String]? = nil,
        forRequest requestIdentifier: RequestIdentifier? = nil,
        check: @escaping (URLRequest) -> Void = { _ in }
    ) -> MockResponse {
        let data = try! encoder.encode(encodable)
        return MockResponse(
            data: data,
            statusCode: statusCode,
            url: url,
            headers: headers,
            requestIdentifier: requestIdentifier,
            check: check
        )
    }
    
    static func file(
        named fileName: String,
        in bundle: Bundle,
        withExtension extensionName: String = "json",
        statusCode: Int = 200,
        url: String = "localhost",
        headers: [String: String]? = nil,
        forRequest requestIdentifier: RequestIdentifier? = nil,
        check: @escaping (URLRequest) -> Void = { _ in }
    ) -> MockResponse {
        let data = try! Data(
            contentsOf: bundle.url(
                forResource: fileName,
                withExtension: extensionName
            )!
        )
        return MockResponse(
            data: data,
            statusCode: statusCode,
            url: url,
            headers: headers,
            requestIdentifier: requestIdentifier,
            check: check
        )
    }
}
