//
//  TextMaskerAccountNumberTests.swift
//  TextMaskerTests
//
//  Created by Don Pironet on 08/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//
import XCTest
import TextMasker

class TextMaskerAccountNumberTests: XCTestCase {
    
    let accountNumberMask = "6703 xxxx xxxx xxxx x"
    
    func testInitMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        XCTAssertEqual(masker.mask, self.accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
    }
    
    func testFillInMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "A")
        
        // Invalid character so nothing replaced
        XCTAssertEqual(result, accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "6703 1xxx xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 6)
        
        result = masker.add(string: "2")
        
        // Valid character
        XCTAssertEqual(result, "6703 12xx xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 7)
        
        result = masker.add(string: "3")
        
        // Valid character
        XCTAssertEqual(result, "6703 123x xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 8)
        
        result = masker.add(string: "4")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 9)
        
        result = masker.add(string: "5")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5xxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.add(string: "6")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 56xx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 12)
        
        result = masker.add(string: "7")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 567x xxxx x")
        XCTAssertEqual(masker.cursorPosition, 13)
        
        result = masker.add(string: "8")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 xxxx x")
        XCTAssertEqual(masker.cursorPosition, 14)
        
        result = masker.add(string: "9")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 9xxx x")
        XCTAssertEqual(masker.cursorPosition, 16)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 91xx x")
        XCTAssertEqual(masker.cursorPosition, 17)
        
        result = masker.add(string: "2")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 912x x")
        XCTAssertEqual(masker.cursorPosition, 18)
        
        result = masker.add(string: "3")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 9123 x")
        XCTAssertEqual(masker.cursorPosition, 19)
        
        result = masker.add(string: "4")
        
        // Valid character
        XCTAssertEqual(result, "6703 1234 5678 9123 4")
        XCTAssertEqual(masker.cursorPosition, 21)
    }
    
    func testCopyPasteFillInMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        let accountNumber = "6703 1234 5678 9123 4"
        let result = masker.add(string: accountNumber)
        
        XCTAssertEqual(result, accountNumber)
        XCTAssertEqual(masker.cursorPosition, 21)
        XCTAssertEqual(masker.currentMaskedInput(), accountNumber)
    }
    
    func testClearMaskWhenFilled() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "6703 1234 5678 9123 4")
        
        result = masker.clear()
        
        XCTAssertEqual(result, self.accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
        XCTAssertEqual(masker.currentMaskedInput(), self.accountNumberMask)
    }
    
    func testClearMaskWhenEmpty() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        let result = masker.clear()
        
        XCTAssertEqual(result, self.accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
        XCTAssertEqual(masker.currentMaskedInput(), self.accountNumberMask)
    }
    
    func testRemoveCharactersInMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "6703 1234 5678 9123 4")
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5678 9123 x")
        XCTAssertEqual(masker.cursorPosition, 20)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5678 912x x")
        XCTAssertEqual(masker.cursorPosition, 18)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5678 91xx x")
        XCTAssertEqual(masker.cursorPosition, 17)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5678 9xxx x")
        XCTAssertEqual(masker.cursorPosition, 16)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5678 xxxx x")
        XCTAssertEqual(masker.cursorPosition, 15)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 567x xxxx x")
        XCTAssertEqual(masker.cursorPosition, 13)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 56xx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 12)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 5xxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1234 xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 10)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 123x xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 8)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 12xx xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 7)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 1xxx xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 6)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "6703 xxxx xxxx xxxx x")
        XCTAssertEqual(masker.cursorPosition, 5)
        
        XCTAssertEqual(result, self.accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
        XCTAssertEqual(masker.currentMaskedInput(), self.accountNumberMask)
    }
    
    func testNothingMoreToDeleteInMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "1")
        result = masker.remove()
        result = masker.remove()
        XCTAssertEqual(result, self.accountNumberMask)
        XCTAssertEqual(masker.cursorPosition, 5)
    }
    
    func testNothingToAddInMask() {
        let masker = TextMasker(
            mask: accountNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        let accountNumber = "6703 1234 5678 9123 4"
        var result = masker.add(string: accountNumber)
        result = masker.add(string: "1")
        XCTAssertEqual(result, accountNumber)
        XCTAssertEqual(masker.cursorPosition, 21)
    }
}

