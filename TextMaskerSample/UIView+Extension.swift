//
//  UIView+Extension.swift
//  TextMaskerSample
//
//  Created by Don Pironet on 08/10/2018.
//  Copyright © 2018 Don Pironet. All rights reserved.
//

import UIKit

public enum Axis {
    case horizontal
    case vertical
    case baseline
}

extension UIView {
    
    @discardableResult
    public func centerInSuperview() -> [Axis: NSLayoutConstraint] {
        var constraints = [Axis: NSLayoutConstraint]()
        if let horizontal = self.align(to: .horizontal) {
            constraints[.horizontal] = horizontal
        }
        if let vertical = self.align(to: .vertical) {
            constraints[.vertical] = vertical
        }
        return constraints
    }
    
    @discardableResult
    public func align(to superviewAxis: Axis) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            assertionFailure("Need to have a superview")
            return nil
        }
        return align(to: superviewAxis, of: superview)
    }
    
    @discardableResult
    public func align(to axis: Axis, of otherView: UIView) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .horizontal:
            let horizontalConstraint = self.centerYAnchor.constraint(equalTo: otherView.centerYAnchor)
            horizontalConstraint.isActive = true
            return horizontalConstraint
        case .vertical:
            let verticalConstraint = self.centerXAnchor.constraint(equalTo: otherView.centerXAnchor)
            verticalConstraint.isActive = true
            return verticalConstraint
        case .baseline:
            let baselineConstraint = self.lastBaselineAnchor.constraint(equalTo: otherView.lastBaselineAnchor)
            baselineConstraint.isActive = true
            return baselineConstraint
        }
    }
}

