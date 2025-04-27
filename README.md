# TCLayoutConstraint
 A lightweight and expressive Swift framework that simplifies the creation and management of Auto Layout constraints.

## ✨ Features
 * Elegant custom operators (=|, >=|, <=|, +, -) for intuitive constraint writing
 * Automatically sets translatesAutoresizingMaskIntoConstraints = false
 * Powerful helpers for edges, size, and center constraints
 * Clean and readable syntax

## Usage

### Set Vertical or Horizontal Constraint
```swift
    view.topAnchor =| superview.topAnchor
    view.leadingAnchor =| superview.leadingAnchor + 15
    view.bottomAnchor =| superview.bottomAnchor
    
    let constraint = (view.trailingAnchor =| superview.trailingAnchor - 15)
    constraint.priority = .defaultLow
    
    view.edgesAnchor =| superview.edgesAnchor
    (label.edgesAnchor =| superview.edgesAnchor).withInsets(TCEdgeInsets(uniform: 15)).excluding(.bottom)
    let buttonEdgesConstraints = (button.edgesAnchor =| superview.edgesAnchor).withInsets(TCEdgeInsets(horizontal: 20, top: 10))
    buttonEdgesConstraints.bottomConstraint.priority = .defaultHigh
```

### Set Width or Height
```swift
    view.widthAnchor =| 100
    view.heightAnchor =| 50
    
    label.widthAnchor =| label.heightAnchor * 2
    
    view.sizeAnchor =| TCSize(width: 100, height: 50)
    view.sizeAnchor =| label.sizeAnchor
```

### Center X and Center Y
```swift
    view.centerXAnchor =| superview.centerXAnchor
    view.centerYAnchor =| superview.centerYAnchor
    
    view.centerAnchor =| superview.centerAnchor
    (label.centerAnchor =| superview.centerAnchor).withOffset(TCOffset(x, 10, y: 50))
    (button.centerAnchor =| superview.centerAnchor).withOffset(TCOffset(y: 50))
```

## 📦 Installation
Simply add the TCLayoutConstraints.swift file to your project.

 Swift Package Manager support coming soon.

