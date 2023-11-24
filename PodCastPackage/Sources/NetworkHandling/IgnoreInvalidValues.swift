//
//  File 2.swift
//  
//
//  Created by Naif Alrashed on 14/02/2022.
//

import Foundation

@propertyWrapper
public struct IgnoreInvalidValues<Wrapping: Decodable>: Decodable {
    public let wrappedValue: [Wrapping]
    
    public init(from decoder: Decoder) throws {
        var contents: [Wrapping] = []
        
        do {
            var container = try decoder.unkeyedContainer()
            while !container.isAtEnd {
                do {
                    contents.append(try container.decode(Wrapping.self))
                } catch {
                    print("-----------------------------")
                    print("for \(type(of: Wrapping.self))")
                    dump(error)
                    print("-----------------------------")
                    let filler = try? container.decode(AlwaysDecodeObjects.self)
                    if filler == nil {
                        print("breaking")
                        break
                    }
                }
            }
            self.wrappedValue = contents
        } catch {
            print("-----------------------------")
            print("for \(type(of: Wrapping.self)), could not decode array")
            dump(error)
            print("-----------------------------")
            self.wrappedValue = []
        }
    }
    
    public init(values: [Wrapping]) {
        self.wrappedValue = values
    }
    
    struct AlwaysDecodeObjects: Decodable {}
}

extension IgnoreInvalidValues: Encodable where Wrapping: Encodable {}
extension IgnoreInvalidValues: Equatable where Wrapping: Equatable {}
extension IgnoreInvalidValues: Hashable where Wrapping: Hashable {}
