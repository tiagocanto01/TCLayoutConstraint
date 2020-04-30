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
```
OR 

```swift
    view.edges(to: superview)
    label.edges(to: superview, insets: .uniform(15))
    button.edgesToSuperview()
```

### Set Width or Height
```swift
    view.width =| 100
    view.height =| 50
    
    label.width =| label.height * 2
```

### Center X and Center Y
```swift
    view.centerX =| superview.centerX
    view.centerY =| superview.centerY
```
OR

```swift
    view.center(in: superview)
    label.centerInSuperview()
```

# Installation
 Just copy TCLayoutContraint to your project
