//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import Logging

struct DecodingError: Error {
    
}

public func decode<ExpectedResponse: Decodable>(
    _ data: Data,
    to: ExpectedResponse.Type,
    using decoder: JSONDecoder = jsonDecoder
) throws -> ExpectedResponse {
    do {
        return try decoder.decode(ExpectedResponse.self, from: data)
    } catch {
        print("failed to decode to \(String(describing: ExpectedResponse.self))")
        print("error ", error)
        print("response body")
        print(String(data: data, encoding: .utf8) ?? "")
        throw error
    }
}

public let jsonDecoder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    return jsonDecoder
}()
