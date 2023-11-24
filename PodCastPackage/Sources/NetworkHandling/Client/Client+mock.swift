//
//  File.swift
//  
//
//  Created by Naif Alrashed on 13/09/2022.
//

import Foundation

public extension Client {
    static func mock(_ responses: MockResponse...) -> Client {
        var responses = responses
        return Client { request in
            
            if let mockResponseAndIndex = responses
                .enumerated()
                .filter({ $0.1.requestIdentifier?.isMatching(request: request) ?? false })
                .first {
                    let (index, mockResponse) = mockResponseAndIndex
                    responses.remove(at: index)
                    mockResponse.check(request)
                    return mockResponse.dataAndResponse
                }

            let mockResponse = responses.removeFirst()
            mockResponse.check(request)
            return mockResponse.dataAndResponse
        }
    }
    
    static func always(return response: MockResponse) -> Client {
        Client { request in
            response.check(request)
            return response.dataAndResponse
        }
    }
}
