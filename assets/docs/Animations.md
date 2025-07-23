> **Note:** This is just one way to create custom transitions. The portal system is flexible and allows for many different animation approaches. A more declarative API for transitions is in development — this API is temporary.

### Creating a Scale-Bounce Transition

We’ll build a reusable view that scales up and snaps back when the portal activates.

#### 1. Define Your Animation Constants

```swift
let transitionDuration: TimeInterval = 0.4

let scaleAnimation = Animation.smooth(
  duration: transitionDuration,
  extraBounce: 0.25
)

let bounceAnimation = Animation.smooth(
  duration: transitionDuration + 0.12,
  extraBounce: 0.55
)
```

#### 2. Create a Custom Transition View

```swift
struct ScaleTransitionView<Content: View>: View {
  @EnvironmentObject private var portalModel: CrossModel
  let id: String
  @ViewBuilder let content: () -> Content

  @State private var scale: CGFloat = 1

  var body: some View {
    // Check whether this portal is animating
    let isActive = portalModel.info
      .first(where: { $0.infoID == id })?
      .animateView ?? false

    content()
      .scaleEffect(scale)
      .onAppear { scale = 1 }
      .onChangeCompat(of: isActive) { newValue in
        if newValue {
          // 1) Scale up
          withAnimation(scaleAnimation) {
            scale = 1.25
          }
          // 2) Bounce back
          DispatchQueue.main.asyncAfter(
            deadline: .now() + (transitionDuration / 2) - 0.1
          ) {
            withAnimation(bounceAnimation) {
              scale = 1
            }
          }
        } else {
          // Reset on deactivate
          withAnimation { scale = 1 }
        }
      }
  }
}
```

#### 3. Apply It to Your Portal

```swift
// 1) Source
ScaleTransitionView(id: "myPortal") {
  RoundedRectangle(cornerRadius: 16).fill(gradient)
}
.frame(width: 100, height: 100)
.portalSource(id: "myPortal")

// 2) Destination
ScaleTransitionView(id: "myPortal") {
  RoundedRectangle(cornerRadius: 16).fill(gradient)
}
.frame(width: 220, height: 220)
.portalDestination(id: "myPortal")

// 3) Transition overlay
.portalTransition(
  id:               "myPortal",
  animate:          $isShowing,
  animation:        scaleAnimation,
  animationDuration: transitionDuration
) {
  ScaleTransitionView(id: "myPortal") {
    RoundedRectangle(cornerRadius: 16).fill(gradient)
  }
}
```

### Summary

1. `ScaleTransitionView` observes portal state via `portalModel`.  
2. On **activate**:
   - It scales up to 1.25× with a smooth curve  
   - After a brief delay, it bounces back to 1.0×  
3. On **deactivate**, it smoothly returns to 1.0×.

### Tips for Further Customization

- Vary the scale factors (e.g. 1.2 → 1.5) to change the “pop” intensity  
- Tweak `extraBounce` and durations for different feels  
- Layer in rotation, opacity, or color effects  
- Combine multiple transforms for rich, complex transitions