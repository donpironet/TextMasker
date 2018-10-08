//
//  TextMaskerNationalSecurityNumberTests.swift
//  TextMaskerTests
//
//  Created by Don Pironet on 05/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import XCTest
import TextMasker

class TextMaskerNationalSecurityNumberTests: XCTestCase {
    let nationalSecurityNumberMask = "xx.xx.xx-xxx.xx"
    
    func testInitMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        XCTAssertEqual(masker.mask, self.nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
    }
    
    func testFillInMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "A")
        
        // Invalid character so nothing replaced
        XCTAssertEqual(result, nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "1x.xx.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 1)
        
        result = masker.add(string: "2")
        
        // Valid character
        XCTAssertEqual(result, "12.xx.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 2)
        
        result = masker.add(string: "3")
        
        // Valid character
        XCTAssertEqual(result, "12.3x.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 4)
        
        result = masker.add(string: "4")
        
        // Valid character
        XCTAssertEqual(result, "12.34.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 5)
        
        result = masker.add(string: "5")
        
        // Valid character
        XCTAssertEqual(result, "12.34.5x-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 7)
        
        result = masker.add(string: "6")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 8)
        
        result = masker.add(string: "7")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-7xx.xx")
        XCTAssertEqual(masker.cursorPosition, 10)
        
        result = masker.add(string: "8")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-78x.xx")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.add(string: "9")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-789.xx")
        XCTAssertEqual(masker.cursorPosition, 12)
        
        result = masker.add(string: "1")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-789.1x")
        XCTAssertEqual(masker.cursorPosition, 14)
        
        result = masker.add(string: "0")
        
        // Valid character
        XCTAssertEqual(result, "12.34.56-789.10")
        XCTAssertEqual(masker.cursorPosition, 15)
    }
    
    func testCopyPasteFillInMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        let nationalNumber = "12.34.56-789.10"
        let result = masker.add(string: nationalNumber)
        
        XCTAssertEqual(result, nationalNumber)
        XCTAssertEqual(masker.cursorPosition, 15)
        XCTAssertEqual(masker.currentMaskedInput(), nationalNumber)
    }
    
    func testClearMaskWhenFilled() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "12.34.56-789.10")
        
        result = masker.clear()
        
        XCTAssertEqual(result, self.nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
        XCTAssertEqual(masker.currentMaskedInput(), self.nationalSecurityNumberMask)
    }
    
    func testClearMaskWhenEmpty() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        let result = masker.clear()
        
        XCTAssertEqual(result, self.nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
        XCTAssertEqual(masker.currentMaskedInput(), self.nationalSecurityNumberMask)
    }
    
    func testRemoveCharactersInMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        
        var result = masker.add(string: "12.34.56-789.10")
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.56-789.1x")
        XCTAssertEqual(masker.cursorPosition, 14)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.56-789.xx")
        XCTAssertEqual(masker.cursorPosition, 13)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.56-78x.xx")
        XCTAssertEqual(masker.cursorPosition, 11)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.56-7xx.xx")
        XCTAssertEqual(masker.cursorPosition, 10)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.56-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 9)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.5x-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 7)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.34.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 6)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.3x.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 4)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "12.xx.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 3)
        
        result = masker.remove()
        
        XCTAssertEqual(result, "1x.xx.xx-xxx.xx")
        XCTAssertEqual(masker.cursorPosition, 1)
        
        result = masker.remove()
        
        XCTAssertEqual(result, self.nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
        XCTAssertEqual(masker.currentMaskedInput(), self.nationalSecurityNumberMask)
    }
    
    func testNothingMoreToDeleteInMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        var result = masker.add(string: "1")
        result = masker.remove()
        result = masker.remove()
        XCTAssertEqual(result, self.nationalSecurityNumberMask)
        XCTAssertEqual(masker.cursorPosition, 0)
    }
    
    func testNothingToAddInMask() {
        let masker = TextMasker(
            mask: nationalSecurityNumberMask,
            validCharacters: CharacterSet.decimalDigits,
            replacementCharacters: CharacterSet(charactersIn: "x")
        )
        let nationalSecurityNumber = "12.34.56-789.10"
        var result = masker.add(string: nationalSecurityNumber)
        result = masker.add(string: "1")
        XCTAssertEqual(result, nationalSecurityNumber)
        XCTAssertEqual(masker.cursorPosition, 15)
    }
}

