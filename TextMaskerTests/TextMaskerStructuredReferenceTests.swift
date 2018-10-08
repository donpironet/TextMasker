//
//  TextMaskerStructuredReferenceTests.swift
//  TextMaskerTests
//
//  Created by Don Pironet on 08/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import XCTest
import TextMasker

class TextMaskerStructuredReferenceTests: XCTestCase {
    
    let structuredReferenceMask = "+++ xxx / xxxx / xxxxx +++"
    
    func testInitMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        XCTAssertEqual(masker.mask, self.structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
    }
    
    func testFillInMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "A")
        
        // Invalid character so nothing replaced
        XCTAssertEqual(result, structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "+++ 1xx / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 5)
        
        result = masker.add(string: "5")
        
        // Valid character
        XCTAssertEqual(result, "+++ 15x / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 6)
        
        result = masker.add(string: "2")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 7)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1xxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.add(string: "2")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 12xx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 12)
        
        result = masker.add(string: "5")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 125x / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 13)
        
        result = masker.add(string: "3")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 14)
        
        result = masker.add(string: "4")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / 4xxxx +++")
        XCTAssertEqual(masker.cursorPosition, 18)
        
        result = masker.add(string: "4")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / 44xxx +++")
        XCTAssertEqual(masker.cursorPosition, 19)
        
        result = masker.add(string: "3")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / 443xx +++")
        XCTAssertEqual(masker.cursorPosition, 20)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / 4431x +++")
        XCTAssertEqual(masker.cursorPosition, 21)
        
        result = masker.add(string: "8")
        
        // Valid character
        XCTAssertEqual(result, "+++ 152 / 1253 / 44318 +++")
        XCTAssertEqual(masker.cursorPosition, 22)
        
        result = masker.add(string: "9")
        
        // Valid character but out of bounds of the mask
        XCTAssertEqual(result, "+++ 152 / 1253 / 44318 +++")
        XCTAssertEqual(masker.cursorPosition, 22)
    }
    
    func testCopyPasteFillInMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        let structuredReference = "+++ 152 / 1253 / 44318 +++"
        let result = masker.add(string: structuredReference)
        
        XCTAssertEqual(result, structuredReference)
        XCTAssertEqual(masker.cursorPosition, 22)
        XCTAssertEqual(masker.currentMaskedInput(), structuredReference)
    }
    
    func testClearMaskWhenFilled() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "+++ 152 / 1253 / 44318 +++")
        
        result = masker.clear()
        
        XCTAssertEqual(result, self.structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
        XCTAssertEqual(masker.currentMaskedInput(), self.structuredReferenceMask)
    }
    
    func testClearMaskWhenEmpty() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        let result = masker.clear()
        
        XCTAssertEqual(result, self.structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
        XCTAssertEqual(masker.currentMaskedInput(), self.structuredReferenceMask)
    }
    
    func testRemoveCharactersInMiddleOfMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "+++ 152 / 1253 / 44318 +++")
        
        masker.moveCursorPosition(to: 11)
        result = masker.remove()
        XCTAssertEqual(result, "+++ 152 / x253 / 44318 +++")
        
        result = masker.add(string: "1")
        XCTAssertEqual(result, "+++ 152 / 1253 / 44318 +++")
    }
    
    func testRemoveCharactersInMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "+++ 152 / 1253 / 44318 +++")
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1253 / 4431x +++")
        XCTAssertEqual(masker.cursorPosition, 21)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1253 / 443xx +++")
        XCTAssertEqual(masker.cursorPosition, 20)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1253 / 44xxx +++")
        XCTAssertEqual(masker.cursorPosition, 19)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1253 / 4xxxx +++")
        XCTAssertEqual(masker.cursorPosition, 18)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1253 / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 17)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 125x / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 13)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 12xx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 12)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / 1xxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 152 / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 10)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 15x / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 6)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ 1xx / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 5)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "+++ xxx / xxxx / xxxxx +++")
        XCTAssertEqual(masker.cursorPosition, 4)
        
        XCTAssertEqual(result, self.structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
        XCTAssertEqual(masker.currentMaskedInput(), self.structuredReferenceMask)
    }
    
    func testNothingMoreToDeleteInMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "1")
        result = masker.remove()
        result = masker.remove()
        XCTAssertEqual(result, self.structuredReferenceMask)
        XCTAssertEqual(masker.cursorPosition, 4)
    }
    
    func testNothingToAddInMask() {
        let masker = TextMasker(
            mask: structuredReferenceMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        let accountNumber = "+++ 152 / 1253 / 44318 +++"
        var result = masker.add(string: accountNumber)
        result = masker.add(string: "1")
        XCTAssertEqual(result, accountNumber)
        XCTAssertEqual(masker.cursorPosition, 22)
    }
}

