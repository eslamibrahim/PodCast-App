//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import Logging

public typealias SessionDependencies = (client : Client, session: Session)

public struct Client {
    let client: (URLRequest) async throws -> (Data, HTTPURLResponse)
    private let logger = Logger(label: "network")
    
    public func load(
        _ request: URLRequest,
        fileName: StaticString = #file,
        lineNumber: UInt = #line,
        function: String = #function
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await client(request)
        if response.statusCode > 400 {
            log(
                request: request,
                statusCode: response.statusCode,
                error: nil,
                responseData: data,
                file: fileName,
                function: function,
                line: lineNumber
            )
        }
        return (data, response)
    }
    
    public func load<Response>(
        _ request: URLRequest,
        handle: ResponseHandler<(Data, HTTPURLResponse), Response>,
        fileName: StaticString = #file,
        lineNumber: UInt = #line,
        function: String = #function
    ) async throws -> Response {
        let response = try await client(request)
        do {
            return try handle.handler(response)
        } catch {
            let (data, httpURLResponse) = response
            log(
                request: request,
                statusCode: httpURLResponse.statusCode,
                error: error,
                responseData: data,
                file: fileName,
                function: function,
                line: lineNumber
            )
            throw error
        }
    }
    
    private func log(
        request: URLRequest,
        statusCode: Int,
        error: Error?,
        responseData: Data,
        file: StaticString = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        var parameters: Logger.Metadata = [:]
        guard let url = request.url else { return }
        parameters["url"] = .string(url.absoluteString)
        if let requestHeaders = request.allHTTPHeaderFields {
            let headers = requestHeaders.reduce(into: "") { partialResult, keyAndValue in
                partialResult.append("\(keyAndValue.key): \(keyAndValue.value)\n")
            }
            parameters["request_headers"] = .string(headers)
        }
        if let requestBody = request.httpBody, let bodyString = String(data: requestBody, encoding: .utf8) {
            parameters["request_body"] = .string(bodyString)
        }
        if let requestMethod = request.httpMethod {
            parameters["request_method"] = .string(requestMethod)
        }
        if let responseString = String(data: responseData, encoding: .utf8) {
            parameters["response_body"] = .string(responseString)
        }
        parameters["response_status_code"] = .stringConvertible(statusCode)
        if let error {
            parameters["error"] = "\(error)"// .value(stringLiteral: error.localizedDescription)
        }
        logger.error("error making a request", metadata: parameters)
    }
}

public protocol ClientProvider {
    var client: Client { get }
}
