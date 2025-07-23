# Portal Animations

Portal provides a comprehensive animation system built around `PortalTransitionConfig`, offering both simple defaults and advanced customization options.

---

## Animation Types

Portal supports two animation types that can be used with `PortalTransitionConfig`:

- **`PortalAnimation`**: iOS 15+ compatible, uses duration-based completion timing
- **`PortalAnimationWithCompletion`**: iOS 17+ only, uses modern completion criteria for precise control

Both types conform to `PortalAnimationProtocol` and can be used interchangeably in `PortalTransitionConfig`.

---

## Animation Configuration

### Basic Animation Setup (iOS 15+)

Portal uses `PortalAnimation` for cross-iOS compatibility:

```swift
// Simple configuration
let config = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
)

// With timing control
let config = PortalTransitionConfig(
    animation: PortalAnimation(
        .smooth(duration: 0.5, extraBounce: 0.1),
        delay: 0.1,
        duration: 0.5
    )
)
```

### iOS 17+ Enhanced Animations

For iOS 17+, use `PortalAnimationWithCompletion` for precise control:

```swift
@available(iOS 17.0, *)
let advancedConfig = PortalTransitionConfig(
    animation: PortalAnimationWithCompletion(
        .smooth(duration: 0.5),
        delay: 0.1,
        completionCriteria: .logicallyComplete
    )
)
```

---

## Corner Styling

Portal supports optional corner radius transitions. The `corners` parameter in `PortalTransitionConfig` is optional:

```swift
// With corner clipping and transitions
let configWithCorners = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8)),
    corners: PortalCorners(
        source: 8,        // Starting corner radius
        destination: 20,  // Ending corner radius
        style: .continuous // Apple's continuous corner style
    )
)

// Without corner clipping (default)
let configWithoutCorners = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
    // corners: nil (default) - no clipping applied
)
```

**Corner Behavior:**
- **When `corners` is provided**: Views are clipped and corner radius transitions smoothly from source to destination values
- **When `corners` is `nil` (default)**: No clipping is applied, allowing content to extend beyond frame boundaries during scaling transitions

**Corner Styles:**
- `.circular` - Traditional circular arc corners
- `.continuous` - Apple's organic continuous corner curve

---

## Visual Feedback During Transitions

Portal examples demonstrate visual feedback during transitions using a custom `AnimatedLayer` component. This provides the "bounce" effect you see when tapping elements in the examples.

### Current Implementation

Visual feedback for Portal transitions is currently implemented as example code rather than a formal API. The examples include an `AnimatedLayer` component that:

- Monitors Portal's internal state through `@Environment(CrossModel.self)` (iOS 17+) or `@EnvironmentObject` (iOS 15+)
- Provides scale animation feedback when transitions are active
- Handles iOS version differences automatically

### Using Visual Feedback in Your App

For now, refer to the source code for implementation details:

- **[`Sources/Portal/Examples/AnimatedLayer.swift`](../Sources/Portal/Examples/AnimatedLayer.swift)** - Complete implementation with iOS version handling
- **[`PortalExample_CardGrid.swift`](../Sources/Portal/Examples/PortalExample_CardGrid.swift)** - Usage examples
- **[`PortalExample_Comparison.swift`](../Sources/Portal/Examples/PortalExample_Comparison.swift)** - More usage patterns

### Animation Constants

The examples use these predefined animation values:

```swift
let portal_animationDuration: TimeInterval = 0.4
let portal_animationExample: Animation = .smooth(duration: 0.4, extraBounce: 0.25)
let portal_animationExampleExtraBounce: Animation = .smooth(duration: 0.52, extraBounce: 0.55)
```

### Future API

A proper API for visual feedback during Portal transitions is planned for a future release. Until then, the example implementation provides a working pattern you can adapt for your needs.

---

## Animation Examples

### Spring-Based Transitions

```swift
// Bouncy spring
let bouncyConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.6, dampingFraction: 0.6))
)

// Smooth spring
let smoothConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
)
```

### iOS 17+ Smooth Animations

```swift
// Basic smooth animation
let smoothConfig = PortalTransitionConfig(
    animation: PortalAnimation(.smooth(duration: 0.4))
)

// Smooth with bounce
let smoothBounceConfig = PortalTransitionConfig(
    animation: PortalAnimation(.smooth(duration: 0.4, extraBounce: 0.2))
)
```

### Custom Timing Curves

```swift
// Ease-in-out
let easeConfig = PortalTransitionConfig(
    animation: PortalAnimation(.easeInOut(duration: 0.5))
)

// Custom timing curve
let customConfig = PortalTransitionConfig(
    animation: PortalAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.6))
)
```

---

## Advanced Animation Patterns

### Staggered Animations

Use delays for staggered effects:

```swift
let staggeredConfig = PortalTransitionConfig(
    animation: PortalAnimation(
        .spring(response: 0.4, dampingFraction: 0.8),
        delay: 0.2  // Delay the start
    )
)
```

### Multi-Phase Animations

Combine different animation phases:

```swift
// Phase 1: Quick scale up
let scaleUpConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.2, dampingFraction: 0.9))
)

// Phase 2: Settle with bounce
let settleConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.6, dampingFraction: 0.6))
)
```

### Corner Morphing

Animate between different corner styles:

```swift
// Card to modal transition
let cardToModalConfig = PortalTransitionConfig(
    animation: PortalAnimation(.smooth(duration: 0.5)),
    corners: PortalCorners(
        source: 12,           // Card corner radius
        destination: 0,       // Modal (no corners)
        style: .continuous
    )
)

// Button to sheet transition
let buttonToSheetConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8)),
    corners: PortalCorners(
        source: 25,           // Pill button
        destination: 16,      // Sheet corners
        style: .continuous
    )
)
```

---

## Animation Best Practices

### Performance Optimization

1. **Use appropriate completion criteria** (iOS 17+):
   ```swift
   PortalAnimationWithCompletion(
       .smooth(duration: 0.4),
       completionCriteria: .removed  // More performant than .logicallyComplete
   )
   ```

2. **Choose efficient animation types**:
   - `.spring()` for natural motion
   - `.smooth()` for iOS 17+ optimized animations
   - Avoid complex `.timingCurve()` for simple transitions

### Visual Consistency

1. **Match your app's animation language**:
   ```swift
   // Consistent with iOS system animations
   let systemConfig = PortalTransitionConfig(
       animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
   )
   ```

2. **Use consistent timing across similar transitions**:
   ```swift
   // Define once, use everywhere
   extension PortalTransitionConfig {
       static let standard = PortalTransitionConfig(
           animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
       )
       
       static let quick = PortalTransitionConfig(
           animation: PortalAnimation(.spring(response: 0.3, dampingFraction: 0.9))
       )
   }
   ```

### Accessibility

Portal animations automatically respect system accessibility settings:

- Reduced motion preferences are honored
- Animation durations scale with accessibility settings
- High contrast modes are supported

---

## Debugging Animations

### Animation Timing

Use completion handlers to debug timing:

```swift
.portalTransition(
    id: "debug",
    config: config,
    isActive: $isActive,
    completion: { success in
        print("Animation completed: \(success)")
    }
) {
    MyLayerView()
}
```

### Visual Debugging

Add visual indicators to your layer views:

```swift
.portalTransition(id: "debug", config: config, isActive: $isActive) {
    MyLayerView()
        .overlay(
            Rectangle()
                .stroke(Color.red, lineWidth: 2)
                .opacity(0.5)
        )
}
```

---

## Migration from Legacy APIs

If you're updating from older Portal versions:

```swift
// Old API (deprecated)
.portalTransition(
    id: "myPortal",
    animate: $isActive,
    animation: .spring(response: 0.4, dampingFraction: 0.8),
    animationDuration: 0.4,
    delay: 0.1
) { ... }

// New API
.portalTransition(
    id: "myPortal",
    config: .init(
        animation: PortalAnimation(
            .spring(response: 0.4, dampingFraction: 0.8),
            delay: 0.1,
            duration: 0.4
        )
    ),
    isActive: $isActive
) { ... }
```

---

The Portal animation system provides the flexibility to create everything from subtle micro-interactions to dramatic scene transitions, all while maintaining performance and accessibility standards.