
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
    
    var edgesAnchor: TCLayoutEdgesAnchor {
        get {
            TCLayoutEdgesAnchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        }
    }
    
    var centerAnchor: TCLayoutCenterAnchor {
        get {
            TCLayoutCenterAnchor(centerX: self.centerXAnchor, centerY: self.centerYAnchor)
        }
    }
    
    var sizeAnchor: TCLayoutSizeAnchor {
        get {
            TCLayoutSizeAnchor(width: self.widthAnchor, height: self.heightAnchor)
        }
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

// MARK: - Edges

// MARK: TCLayoutEdgesAnchor
class TCLayoutEdgesAnchor {
    
    var topAnchor: NSLayoutYAxisAnchor
    var leadingAnchor: NSLayoutXAxisAnchor
    var bottomAnchor: NSLayoutYAxisAnchor
    var trailingAnchor: NSLayoutXAxisAnchor
    
    init(top: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, trailing: NSLayoutXAxisAnchor) {
        self.topAnchor = top
        self.leadingAnchor = leading
        self.bottomAnchor = bottom
        self.trailingAnchor = trailing
    }
    
    @discardableResult
    static func =| (left: TCLayoutEdgesAnchor, right: TCLayoutEdgesAnchor) -> TCEdgesConstraints {
        
        let leadingConstraint = left.leadingAnchor =| right.leadingAnchor
        let trailingConstraint = left.trailingAnchor =| right.trailingAnchor
        let topConstraint = left.topAnchor =| right.topAnchor
        let bottomConstraint = left.bottomAnchor =| right.bottomAnchor
        
        return TCEdgesConstraints(top: topConstraint, leading: leadingConstraint, bottom: bottomConstraint, trailing: trailingConstraint)
    }
}

// MARK: TCEdgesConstraints
class TCEdgesConstraints {
    
    enum Option {
        case top
        case leading
        case bottom
        case trailing
    }
    
    private(set) var topConstraint: NSLayoutConstraint?
    private(set) var leadingConstraint: NSLayoutConstraint?
    private(set) var bottomConstraint: NSLayoutConstraint?
    private(set) var trailingConstraint: NSLayoutConstraint?
    
    init(top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        self.topConstraint = top
        self.leadingConstraint = leading
        self.bottomConstraint = bottom
        self.trailingConstraint = trailing
    }
    
    @discardableResult
    func withInsets(_ insets: TCEdgeInsets) -> TCEdgesConstraints {
        self.topConstraint?.constant += insets.top
        self.leadingConstraint?.constant += insets.leading
        self.bottomConstraint?.constant -= insets.bottom
        self.trailingConstraint?.constant -= insets.trailing
        
        return self
    }
    
    @discardableResult
    func excluding(_ edgeOptions: Option...) -> TCEdgesConstraints {
        
        if edgeOptions.contains(.top) {
            self.topConstraint?.isActive = false
            self.topConstraint = nil
        }
        
        if edgeOptions.contains(.leading) {
            self.leadingConstraint?.isActive = false
            self.leadingConstraint = nil
        }
        
        if edgeOptions.contains(.bottom) {
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = nil
        }
        
        if edgeOptions.contains(.trailing) {
            self.trailingConstraint?.isActive = false
            self.trailingConstraint = nil
        }
        
        return self
    }
}

// MARK: TCEdgeInsets
struct TCEdgeInsets {
    
    var top: CGFloat = 0
    var leading: CGFloat = 0
    var bottom: CGFloat = 0
    var trailing: CGFloat = 0

    init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top       : vertical,
                  leading   : horizontal,
                  bottom    : vertical,
                  trailing  : horizontal)
    }
    
    init(horizontal: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top       : top,
                  leading   : horizontal,
                  bottom    : bottom,
                  trailing  : horizontal)
    }
    
    init(vertical: CGFloat, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top       : vertical,
                  leading   : leading,
                  bottom    : vertical,
                  trailing  : trailing)
    }
    
    init(uniform: CGFloat) {
        self.init(top       : uniform,
                  leading   : uniform,
                  bottom    : uniform,
                  trailing  : uniform)
    }
}

// MARK: - Center

// MARK: TCLayoutCenterAnchor
class TCLayoutCenterAnchor {
    
    var centerXAnchor: NSLayoutXAxisAnchor
    var centerYAnchor: NSLayoutYAxisAnchor
    
    init(centerX: NSLayoutXAxisAnchor, centerY: NSLayoutYAxisAnchor) {
        self.centerXAnchor = centerX
        self.centerYAnchor = centerY
    }
    
    @discardableResult
    static func =| (left: TCLayoutCenterAnchor, right: TCLayoutCenterAnchor) -> TCCenterConstraints {
        let centerXConstraint = left.centerXAnchor =| right.centerXAnchor
        let centerYConstraint = left.centerYAnchor =| right.centerYAnchor
        
        return TCCenterConstraints(centerX: centerXConstraint, centerY: centerYConstraint)
    }
}


// MARK: TCCenterConstraints
class TCCenterConstraints {
    
    private(set) var centerXConstraint: NSLayoutConstraint
    private(set) var centerYConstraint: NSLayoutConstraint
    
    init(centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        self.centerXConstraint = centerX
        self.centerYConstraint = centerY
    }
    
    @discardableResult
    func withOffset(_ offset: TCOffset) -> TCCenterConstraints {
        self.centerXConstraint.constant += offset.x
        self.centerYConstraint.constant += offset.y
        
        return self
    }
}

struct TCOffset {
    var x: CGFloat = 0
    var y: CGFloat = 0
}

// MARK: - Size

// MARK: TCLayoutSizeAnchor
class TCLayoutSizeAnchor {
    
    var widthAnchor: NSLayoutDimension
    var heightAnchor: NSLayoutDimension
    
    init(width: NSLayoutDimension, height: NSLayoutDimension) {
        self.widthAnchor = width
        self.heightAnchor = height
    }
    
    @discardableResult
    static func =| (left: TCLayoutSizeAnchor, right: TCLayoutSizeAnchor) -> TCSizeConstraints {
        let widthConstraint = left.widthAnchor =| right.widthAnchor
        let heightConstraint = left.heightAnchor =| right.heightAnchor
        
        return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
    }
}


// MARK: TCSizeConstraints
class TCSizeConstraints {
    
    private(set) var widthConstraint: NSLayoutConstraint
    private(set) var heightConstraint: NSLayoutConstraint
    
    init(width: NSLayoutConstraint, height: NSLayoutConstraint) {
        self.widthConstraint = width
        self.heightConstraint = height
    }
    
    var constant: TCSize {
        get {
            TCSize(width: self.widthConstraint.constant, height: self.heightConstraint.constant)
        }
        
        set {
            self.widthConstraint.constant = newValue.width
            self.heightConstraint.constant = newValue.height
        }
    }
}

// MARK: TCSize
struct TCSize {
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    init(squareSide: CGFloat) {
        self.width = squareSide
        self.height = squareSide
    }
}

@discardableResult
func =| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor =| size.width
    let heightConstraint = sizeAnchor.heightAnchor =| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}

@discardableResult
func >=| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor >=| size.width
    let heightConstraint = sizeAnchor.heightAnchor >=| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}

@discardableResult
func <=| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor <=| size.width
    let heightConstraint = sizeAnchor.heightAnchor <=| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}
