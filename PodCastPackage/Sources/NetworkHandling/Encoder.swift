//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

public extension Optional where Wrapped == Data {
    static func encode<Object: Encodable>(
        _ encodable: Object,
        to encodeType: EncodedType = .json
    ) -> Data? {
        encodeType.encode(encodable)
    }
}

public enum EncodedType {
    case json
    case urlFormEncoded
    
    func encode<Object: Encodable>(_ encodable: Object) -> Data? {
        switch self {
        case .json:
            return try? JSONEncoder().encode(encodable)
        case .urlFormEncoded:
            return try? URLEncodedFormEncoder().encode(encodable)
        }
    }
}
