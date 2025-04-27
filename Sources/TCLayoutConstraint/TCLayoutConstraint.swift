//
//  TCLayoutConstraints.swift
//  Constraints
//
//  Created by Tiago Canto on 12/04/20.
//  Copyright © 2020 Aplicativos Legais. All rights reserved.
//

import UIKit

infix operator =|: AdditionPrecedence
infix operator >=|: AdditionPrecedence
infix operator <=|: AdditionPrecedence

public enum LayoutType {
    case frameBased
    case autolayout
}

public extension UIView {
    
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
        TCLayoutEdgesAnchor(top: topAnchor,
                            leading: leadingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor)
    }
    
    var centerAnchor: TCLayoutCenterAnchor {
        TCLayoutCenterAnchor(centerX: centerXAnchor,
                             centerY: centerYAnchor)
    }
    
    var sizeAnchor: TCLayoutSizeAnchor {
        TCLayoutSizeAnchor(width: widthAnchor,
                           height: heightAnchor)
    }
    
    @discardableResult
    func pinEdgesToSuperview(insets: TCEdgeInsets = .init()) -> TCEdgesConstraints? {
        guard let superview else { return nil }
        return (self.edgesAnchor =| superview.edgesAnchor).withInsets(insets)
    }
    
    @discardableResult
    func pinEdges(to view: UIView, insets: TCEdgeInsets = .init()) -> TCEdgesConstraints {
        return (self.edgesAnchor =| view.edgesAnchor).withInsets(insets)
    }
}

public extension NSLayoutConstraint {
    
    fileprivate func setViewToAutolayout() {

        if let firstView = self.firstItem as? UIView, firstView.layoutType != .autolayout {
            firstView.layoutType = .autolayout
        }
    }
    
    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

public extension NSLayoutXAxisAnchor {
    
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

public extension NSLayoutYAxisAnchor {
    
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

public struct LayoutMultiplierResult {
    public var dimension: NSLayoutDimension
    public var multiplier: CGFloat
}

public extension NSLayoutDimension {
    
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

@MainActor
@discardableResult
public func - (right: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    right.constant -= constant
    return right
}

@MainActor
@discardableResult
public func + (right: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
    right.constant += constant
    return right
}

// MARK: - Edges

// MARK: TCLayoutEdgesAnchor
@MainActor
public struct TCLayoutEdgesAnchor {
    
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
    public static func =| (left: TCLayoutEdgesAnchor, right: TCLayoutEdgesAnchor) -> TCEdgesConstraints {
        
        let leadingConstraint = left.leadingAnchor =| right.leadingAnchor
        let trailingConstraint = left.trailingAnchor =| right.trailingAnchor
        let topConstraint = left.topAnchor =| right.topAnchor
        let bottomConstraint = left.bottomAnchor =| right.bottomAnchor
        
        return TCEdgesConstraints(top: topConstraint,
                                  leading: leadingConstraint,
                                  bottom: bottomConstraint,
                                  trailing: trailingConstraint)
    }
}

// MARK: TCEdgesConstraints
@MainActor
public class TCEdgesConstraints {
    
    public enum Option {
        case top
        case leading
        case bottom
        case trailing
    }
    
    public private(set) var topConstraint: NSLayoutConstraint?
    public private(set) var leadingConstraint: NSLayoutConstraint?
    public private(set) var bottomConstraint: NSLayoutConstraint?
    public private(set) var trailingConstraint: NSLayoutConstraint?
    
    init(top: NSLayoutConstraint, leading: NSLayoutConstraint, bottom: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        self.topConstraint = top
        self.leadingConstraint = leading
        self.bottomConstraint = bottom
        self.trailingConstraint = trailing
    }
    
    @discardableResult
    public func withInsets(_ insets: TCEdgeInsets) -> TCEdgesConstraints {
        self.topConstraint?.constant = insets.top
        self.leadingConstraint?.constant = insets.leading
        self.bottomConstraint?.constant = -insets.bottom
        self.trailingConstraint?.constant = -insets.trailing
        
        return self
    }
    
    @discardableResult
    public func excluding(_ edgeOptions: Option...) -> TCEdgesConstraints {
        
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
public struct TCEdgeInsets {
    
    public var top: CGFloat = 0
    public var leading: CGFloat = 0
    public var bottom: CGFloat = 0
    public var trailing: CGFloat = 0

    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
    
    public init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top:      vertical,
                  leading:  horizontal,
                  bottom:   vertical,
                  trailing: horizontal)
    }
    
    public init(horizontal: CGFloat, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top:      top,
                  leading:  horizontal,
                  bottom:   bottom,
                  trailing: horizontal)
    }
    
    public init(vertical: CGFloat, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top:      vertical,
                  leading:  leading,
                  bottom:   vertical,
                  trailing: trailing)
    }
    
    public init(uniform: CGFloat) {
        self.init(top:      uniform,
                  leading:  uniform,
                  bottom:   uniform,
                  trailing: uniform)
    }
}

// MARK: - Center

// MARK: TCLayoutCenterAnchor
@MainActor
public struct TCLayoutCenterAnchor {
    
    public private(set) var centerXAnchor: NSLayoutXAxisAnchor
    public private(set) var centerYAnchor: NSLayoutYAxisAnchor
    
    init(centerX: NSLayoutXAxisAnchor, centerY: NSLayoutYAxisAnchor) {
        self.centerXAnchor = centerX
        self.centerYAnchor = centerY
    }
    
    @discardableResult
    public static func =| (left: TCLayoutCenterAnchor, right: TCLayoutCenterAnchor) -> TCCenterConstraints {
        let centerXConstraint = left.centerXAnchor =| right.centerXAnchor
        let centerYConstraint = left.centerYAnchor =| right.centerYAnchor
        
        return TCCenterConstraints(centerX: centerXConstraint, centerY: centerYConstraint)
    }
}

// MARK: TCCenterConstraints
@MainActor
public class TCCenterConstraints {
    
    public private(set) var centerXConstraint: NSLayoutConstraint
    public private(set) var centerYConstraint: NSLayoutConstraint
    
    init(centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        self.centerXConstraint = centerX
        self.centerYConstraint = centerY
    }
    
    @discardableResult
    public func withOffset(_ offset: TCOffset) -> TCCenterConstraints {
        self.centerXConstraint.constant += offset.x
        self.centerYConstraint.constant += offset.y
        
        return self
    }
}

public struct TCOffset {
    public var x: CGFloat = 0
    public var y: CGFloat = 0
}

// MARK: - Size

// MARK: TCLayoutSizeAnchor
@MainActor
public struct TCLayoutSizeAnchor {
    
    public private(set) var widthAnchor: NSLayoutDimension
    public private(set) var heightAnchor: NSLayoutDimension
    
    init(width: NSLayoutDimension, height: NSLayoutDimension) {
        self.widthAnchor = width
        self.heightAnchor = height
    }
    
    @discardableResult
    public static func =| (left: TCLayoutSizeAnchor, right: TCLayoutSizeAnchor) -> TCSizeConstraints {
        let widthConstraint = left.widthAnchor =| right.widthAnchor
        let heightConstraint = left.heightAnchor =| right.heightAnchor
        
        return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
    }
}

// MARK: - TCSizeConstraints
@MainActor
public class TCSizeConstraints {
    
    public private(set) var widthConstraint: NSLayoutConstraint
    public private(set) var heightConstraint: NSLayoutConstraint
    
    init(width: NSLayoutConstraint, height: NSLayoutConstraint) {
        self.widthConstraint = width
        self.heightConstraint = height
    }
    
    public var constant: TCSize {
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
public struct TCSize {
    
    public var width: CGFloat = 0
    public var height: CGFloat = 0
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public init(squareSide: CGFloat) {
        self.width = squareSide
        self.height = squareSide
    }
}

@MainActor
@discardableResult
public func =| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor =| size.width
    let heightConstraint = sizeAnchor.heightAnchor =| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}

@MainActor
@discardableResult
public func >=| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor >=| size.width
    let heightConstraint = sizeAnchor.heightAnchor >=| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}

@MainActor
@discardableResult
public func <=| (sizeAnchor: TCLayoutSizeAnchor, size: TCSize) -> TCSizeConstraints {
    
    let widthConstraint = sizeAnchor.widthAnchor <=| size.width
    let heightConstraint = sizeAnchor.heightAnchor <=| size.height
    
    return TCSizeConstraints(width: widthConstraint, height: heightConstraint)
}
