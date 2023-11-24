//
//  File.swift
//  
//
//  Created by Naif Alrashed on 13/09/2022.
//

import Foundation
import Pulse

public extension URLSession {
    func request(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await self.data(for: request)
            let httpResponse = response as! HTTPURLResponse
            LoggerStore.shared.storeRequest(
                request,
                response: response,
                error: nil,
                data: data
            )
            return (data, httpResponse)
        } catch {
            LoggerStore.shared.storeRequest(
                request,
                response: nil,
                error: error,
                data: nil
            )
            throw error
        }
    }
}
