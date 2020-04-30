//
//  TCLayoutConstraints.swift
//  Constraints
//
//  Created by Tiago Canto on 12/04/20.
//  Copyright © 2020 Aplicativos Legais. All rights reserved.
//

import UIKit

infix operator =| : AdditionPrecedence
infix operator >=| : AdditionPrecedence
infix operator <=| : AdditionPrecedence


struct ConstraintEdgeInsets {
    
    var top: CGFloat = 0
    var leading: CGFloat = 0
    var bottom: CGFloat = 0
    var trailing: CGFloat = 0
    
    static let zero = ConstraintEdgeInsets()
    
    static func uniform(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
    
    static func top(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(top: value)
    }
    
    static func leading(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(leading: value)
    }
    
    static func bottom(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(bottom: value)
    }
    
    static func trailing(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(trailing: value)
    }
    
    static func horizontal(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(leading: value, trailing: value)
    }
    
    static func vertical(_ value: CGFloat) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(top: value, bottom: value)
    }
    
    static func + (lhs: ConstraintEdgeInsets, rhs: ConstraintEdgeInsets) -> ConstraintEdgeInsets {
        ConstraintEdgeInsets(top:       lhs.top + rhs.top,
                             leading:   lhs.leading + rhs.leading,
                             bottom:    lhs.bottom + rhs.bottom,
                             trailing:  lhs.trailing + rhs.trailing)
    }
}

enum LayoutType {
    case frameBased
    case autolayout
}

extension UIView {
    
    var layoutType: LayoutType {
        
        get {
            self.translatesAutoresizingMaskIntoConstraints ? .frameBased : .autolayout
        }
        
        set {
            switch newValue {
            case .frameBased:
                self.translatesAutoresizingMaskIntoConstraints = true
            case .autolayout:
                self.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    func edges(to view: UIView, insets: ConstraintEdgeInsets = .zero) {
        self.topAnchor =| view.topAnchor + insets.top
        self.leadingAnchor =| view.leadingAnchor + insets.leading
        self.bottomAnchor =| view.bottomAnchor - insets.bottom
        self.trailingAnchor =| view.trailingAnchor - insets.trailing
    }
    
    func edgesToSuperview(insets: ConstraintEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        self.edges(to: superview, insets: insets)
    }
    
    func center(in view: UIView, offset: CGPoint = .zero) {
        self.centerXAnchor =| view.centerXAnchor + offset.x
        self.centerYAnchor =| view.centerYAnchor + offset.y
    }
    
    func centerInSuperview(offset: CGPoint = .zero) {
        guard let superview = self.superview else { return }
        self.center(in: superview, offset: offset)
    }
}

extension NSLayoutConstraint {
    
    fileprivate func setViewToAutolayout() {

        if let firstView = self.firstItem as? UIView, firstView.layoutType != .autolayout {
            firstView.layoutType = .autolayout
        }
    }
}

extension NSLayoutXAxisAnchor {
    
    @discardableResult
    static func =| (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(equalTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func >=| (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(greaterThanOrEqualTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func <=| (left: NSLayoutXAxisAnchor, right: NSLayoutXAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(lessThanOrEqualTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    
    @discardableResult
    static func =| (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(equalTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func >=| (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(greaterThanOrEqualTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func <=| (left: NSLayoutYAxisAnchor, right: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
        let constraint = left.constraint(lessThanOrEqualTo: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
}

struct LayoutMultiplierResult {
    var dimension: NSLayoutDimension
    var multiplier: CGFloat
}

extension NSLayoutDimension {
    
    @discardableResult
    static func =| (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        let constraint = left.constraint(equalToConstant: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    static func =| (left: NSLayoutDimension, right: NSLayoutDimension) -> NSLayoutConstraint {
        let constraint = left.constraint(equalTo: right, multiplier: 1)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func =| (left: NSLayoutDimension, right: LayoutMultiplierResult) -> NSLayoutConstraint {
        let constraint = left.constraint(equalTo: right.dimension, multiplier: right.multiplier)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func * (right: NSLayoutDimension, multiplier: CGFloat) -> LayoutMultiplierResult {
        LayoutMultiplierResult(dimension: right, multiplier: multiplier)
    }
    
    @discardableResult
    static func >=| (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        let constraint = left.constraint(greaterThanOrEqualToConstant: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    static func <=| (left: NSLayoutDimension, right: CGFloat) -> NSLayoutConstraint {
        let constraint = left.constraint(lessThanOrEqualToConstant: right)
        constraint.setViewToAutolayout()
        constraint.isActive = true
        return constraint
    }
}

@discardableResult
func - (right: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    right.constant -= constant
    return right
}

@discardableResult
func + (right: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    right.constant += constant
    return right
}
