//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

public struct ResponseHandler<Input, Output> {
    let handler: (Input) throws -> Output
    
    public init(handler: @escaping (Input) throws -> Output) {
        self.handler = handler
    }
    
    public func then<NewOutput>(
        _ responseHandler: ResponseHandler<Output, NewOutput>
    ) -> ResponseHandler<Input, NewOutput> {
        return ResponseHandler<Input, NewOutput>.init { input in
            let output = try self.handler(input)
            return try responseHandler.handler(output)
        }
    }
}

public extension ResponseHandler {
    
    static func decoding<DecodableObject: Decodable>(
        to jsonType: DecodableObject.Type,
        using decoder: JSONDecoder = JSONDecoder(),
        onError errorType: BackendErrorType
    ) -> ResponseHandler<(Data, HTTPURLResponse), DecodableObject> {
        .error(as: errorType).then(.decoding(to: jsonType, using: decoder))
    }
    
    static func error(
        as errorType: BackendErrorType
    ) -> ResponseHandler<(Data, HTTPURLResponse), (Data, HTTPURLResponse)> {
        .init { (data, response) in
            if response.statusCode >= 400 {
                throw errorType.decode(data)
            }
            return (data, response)
        }
    }
    
    static func error(
        as errorType: BackendErrorType,
        against range: ClosedRange<Int>
    ) -> ResponseHandler<(Data, HTTPURLResponse), (Data, HTTPURLResponse)> {
        .init { (data, response) in
            if !range.contains(response.statusCode) {
                throw errorType.decode(data)
            }
            return (data, response)
        }
    }
    
    static func decoding<DecodableObject: Decodable>(
        to jsonType: DecodableObject.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> ResponseHandler<(Data, HTTPURLResponse), DecodableObject> {
        .init { data, _ in
            do {
                return try decoder.decode(DecodableObject.self, from: data)
            } catch {
                print("failed to decode to \(String(describing: DecodableObject.self))")
                print("response body ", error)
                print(String(data: data, encoding: .utf8) ?? "")
                throw error
            }
        }
    }
}

public struct BackendErrorType {
    private let decode: (Data) throws -> Error
    
    public init(decode: @escaping (Data) throws -> Error) {
        self.decode = decode
    }
    
    func decode(_ data: Data) -> Error {
        do {
            return try decode(data)
        } catch {
            print("failed to decode error")
            print("response body")
            print(String(data: data, encoding: .utf8) ?? "")
            return error
        }
    }
}
