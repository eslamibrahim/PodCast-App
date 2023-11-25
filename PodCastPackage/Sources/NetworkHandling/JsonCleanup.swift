//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation

fileprivate let openBracketObject = "{".utf8.first!
fileprivate let openBracketArray = "[".utf8.first!
fileprivate let closeBracketObject = "}".utf8.first!
fileprivate let closeBracketArray = "]".utf8.first!

extension Data {
    public mutating func tryToMakeValidJson() {
        let before = self
        while isSurroundedWithInvalidJson {
            if isNotJson {
                self = before
                break
            }
            
            if isFirstInValidJson {
                removeFirst()
            }
            if isLastInvalidJson {
                removeLast()
            }
        }
    }
    
    private var isNotJson: Bool {
        isEmpty || count == 1
    }
    
    private var isSurroundedWithInvalidJson: Bool {
        isFirstInValidJson || isLastInvalidJson
    }
    
    private var isFirstInValidJson: Bool {
        first != openBracketObject && first != openBracketArray
    }
    
    private var isLastInvalidJson: Bool {
        last != closeBracketObject && last != closeBracketArray
    }
}
