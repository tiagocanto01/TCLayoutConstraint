# TCLayoutConstraint
 Syntactic sugar that makes Auto Layout easier and readable

## Examples
Don't need to activate the constraints, and don't need to set translatesAutoresizingMaskIntoConstraints to false.
Each line returns a NSLayoutContraint

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
    view.sizeAnchor =| labe.sizeAnchor
```

### Center X and Center Y
```swift
    view.centerXAnchor =| superview.centerXAnchor
    view.centerYAnchor =| superview.centerYAnchor
    
    view.centerAnchor =| superview.centerAnchor
    (label.centerAnchor =| superview.centerAnchor).withOffset(TCOffset(x, 10, y: 50))
    (button.centerAnchor =| superview.centerAnchor).withOffset(TCOffset(y: 50))
```

# Installation
 Just copy TCLayoutContraint to your project
