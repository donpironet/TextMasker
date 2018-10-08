//
//  UITextField+Extension.swift
//  TextMaskerSample
//
//  Created by Don Pironet on 08/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import UIKit

extension UITextField {
    func setCursor(to position: Int) {
        if let newPosition = self.position(from: self.beginningOfDocument, offset: position) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
}
