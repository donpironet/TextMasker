//
//  ViewController.swift
//  TextMaskerSample
//
//  Created by Don Pironet on 05/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import UIKit
import TextMasker

class ViewController: UIViewController {
    
    let textField: UITextField = UITextField(frame: .zero)
    var masker: TextMasker!
    
    private let nationalSecurityNumberMask = "xx.xx.xx-xxx.xx"
    private let accountNumberMask = "6703 xxxx xxxx xxxx x"
    private let communicationMask = "+++ xxx / xxxx / xxxxx +++"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let validCharacters = CharacterSet.decimalDigits
        let replaceCharacters = CharacterSet(charactersIn: "x")
        self.masker = TextMasker(mask: self.communicationMask, validCharacters: validCharacters, replacementCharacters: replaceCharacters)
        
        self.textField.text = self.masker.mask
        self.textField.delegate = self
        
        self.textField.font = UIFont(name: "couriernewpsmt", size: 14)
        
        self.view.addSubview(self.textField)
        self.textField.centerInSuperview()
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let currentPositionInMask = self.masker.cursorPosition
        textField.setCursor(to: currentPositionInMask)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = string == "" ? self.masker.remove() : self.masker.add(string: string)
        textField.text = result
        
        let currentPositionInMask = self.masker.cursorPosition
        textField.setCursor(to: currentPositionInMask)
        
        return false
    }
}
