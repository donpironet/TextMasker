//
//  TextMasker.swift
//  TextMasker
//
//  Created by Don Pironet on 05/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import Foundation

/*
 This class can be used to mask a input text.
 
 Input:
 mask: the mask the user needs to fill in for example: xx-xx
 validCharacters: the allowed characters a user can enter. For example only digits
 replacementCharacters: the characters in the mask that can be replaced by validCharacters by the user. In this example only the x's can be replaced.
 */
public class TextMasker {
    
    public let mask: String
    private let validCharacters: CharacterSet
    private let replacementCharacters: CharacterSet
    
    private var input: String
    private (set) public var cursorPosition: Int = 0
    
    public init(mask: String, validCharacters: CharacterSet, replacementCharacters: CharacterSet) {
        self.mask = mask
        self.input = mask
        self.validCharacters = validCharacters
        self.replacementCharacters = replacementCharacters
        
        self.cursorPosition = self.nextPositionInMask()
    }
    
    public func currentMaskedInput() -> String {
        return self.input
    }
    
    public func add(string: String) -> String {
        guard self.cursorPosition < self.mask.count else {
            return self.input
        }
        
        var string = string
        
        // copy paste flow. Substring the input according to the mask
        if string.count > 1 && string.count <= self.mask.count && self.mask == self.input {
            string = string[self.cursorPosition..<string.count]
        }
        
        for character in string {
            self.replaceAndIncrementPosition(for: String(character))
        }
        
        return self.input
    }
    
    public func clear() -> String {
        self.input = self.mask
        self.cursorPosition = 0
        self.cursorPosition = self.nextPositionInMask()
        return self.input
    }
    
    public func remove() -> String {
        let position = self.previousPositionInMask()
        let originalMaskString: String = self.mask[position]
        let positionIndex = self.input.index(self.input.startIndex, offsetBy: position)
        let range = positionIndex..<self.input.index(positionIndex, offsetBy: originalMaskString.count)
        self.input = self.input.replacingCharacters(in: range, with: originalMaskString)
        self.cursorPosition = position
        
        return self.input
    }
    
    public func moveCursorPosition(to position: Int) {
        guard position < self.mask.count else { return }
        self.cursorPosition = position
    }
    
    private func replaceAndIncrementPosition(for string: String) {
        if !self.isMaskCompletelyFilled() && self.isValidInputCharacter(string) {
            let nextPosition = self.nextPositionInMask()
            if (nextPosition + string.count) <= self.input.count {
                let nextPositionIndex = self.input.index(self.input.startIndex, offsetBy: nextPosition)
                let range = nextPositionIndex..<self.input.index(nextPositionIndex, offsetBy: string.count)
                self.input = self.input.replacingCharacters(in: range, with: string)
                self.cursorPosition = nextPosition + string.count
            }
        }
    }
    
    private func nextPositionInMask() -> Int {
        if self.cursorPosition >= self.mask.count {
            return self.cursorPosition
        }
        
        let currentPositionCharacter: String = self.mask[self.cursorPosition]
        if isValidReplacementCharacter(currentPositionCharacter) {
            return self.cursorPosition
        } else {
            let position = self.cursorPosition + 1
            for cursor in position..<self.mask.count {
                let currentPositionCharacter: String = self.mask[cursor]
                if isValidReplacementCharacter(currentPositionCharacter) {
                    return cursor
                }
            }
        }
        return self.cursorPosition
    }
    
    private func previousPositionInMask() -> Int {
        if self.cursorPosition <= 0 {
            return self.cursorPosition
        }
        
        let position = self.cursorPosition - 1
        for cursor in (0...position).reversed() {
            let currentPositionCharacter: String = self.mask[cursor]
            if isValidReplacementCharacter(currentPositionCharacter) {
                return cursor
            }
        }
        return self.cursorPosition
    }
    
    private func isValidReplacementCharacter(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: self.replacementCharacters) != nil
    }
    
    private func isValidInputCharacter(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: self.validCharacters) != nil
    }
    
    public func isMaskCompletelyFilled() -> Bool {
        return self.input.rangeOfCharacter(from: self.replacementCharacters) == nil
    }
    
    public func isMaskEmpty() -> Bool {
        return self.input == self.mask
    }
}
