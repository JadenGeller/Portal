Portal's "magic" comes from decoupling your source and destination views and rendering the transition in a lightweight overlay window.

### 1. Set Up the Overlay
Wrap your root view in a `PortalContainer` or use the `.portalContainer()` extension:

```swift
// Method 1: Direct wrapping
PortalContainer {
  // … your app's root content …
}

// Method 2: Extension method
MyRootView()
  .portalContainer()
```

Under the hood, PortalContainer:

- Installs a transparent, non-blocking `PassThroughWindow` above your normal hierarchy
- Hosts a single `PortalLayerView` that renders all floating layers during transitions
- Manages the overlay window lifecycle based on scene phase changes
- Uses `OverlayWindowManager` to coordinate window creation and cleanup

![Architecture](https://github.com/user-attachments/assets/998eaf85-598e-4b13-8f1c-8890f5d7aa8f)

---

### 2. Mark Your Views
Tell Portal which two views to animate using either string IDs or `Identifiable` items:

```swift
// Method 1: String-based IDs
.portalSource(id: "heroCard")
.portalDestination(id: "heroCard")

// Method 2: Identifiable items
.portalSource(item: myCard)
.portalDestination(item: myCard)
```

Behind the scenes, each modifier:

- Captures its view's bounding rectangle via an `AnchorPreference`
- Stores that geometry in a shared `CrossModel` keyed by your `id`
- Uses iOS 17+ `@Environment(CrossModel.self)` or iOS 15+ `@EnvironmentObject` for state management
- Automatically handles opacity changes to hide/show views during transitions

![Source & Destination Capture](https://github.com/user-attachments/assets/6113ccb6-c6a8-4dc4-a5a9-f9a8e1ca25b0)

---

### 3. Trigger the Transition
On the view that presents your detail (sheet, push, etc.), attach a portal transition:

```swift
// Method 1: Boolean-driven transitions
.portalTransition(
  id: "heroCard",                           // matches your source/destination
  config: .init(                            // comprehensive configuration
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8)),
    corners: PortalCorners(source: 8, destination: 16, style: .continuous)
  ),
  isActive: $isShowingDetail               // Binding<Bool> drives the animation
) {
  // The floating layer shown during the animation
  MyFloatingView()
}

// Method 2: Item-driven transitions
.portalTransition(
  item: $selectedCard,                     // Binding<Optional<Item>>
  config: .init(animation: PortalAnimation(.smooth(duration: 0.4)))
) { card in
  // The floating layer, with access to the item
  CardView(card: card)
}
```

![portalTransition](https://github.com/user-attachments/assets/4299f10f-5216-4721-934a-5e3e22353263)

- Flipping `isActive` to `true` or setting `item` to non-nil moves the overlay from source → destination
- Flipping back or setting to `nil` reverses the animation
- The overlay is only visible during the transition; original views are restored afterward

![Portal Transition Flow](https://github.com/user-attachments/assets/db772732-37ed-4418-a770-38e2cd18d912)

---

### 4. Advanced Configuration

Portal uses `PortalTransitionConfig` for comprehensive control. The configuration accepts either `PortalAnimation` or `PortalAnimationWithCompletion` for the animation parameter:

**Basic Configuration (iOS 15+):**

```swift
// With corner clipping
let config = PortalTransitionConfig(
  animation: PortalAnimation(
    .spring(response: 0.5, dampingFraction: 0.8),
    delay: 0.1,
    duration: 0.5
  ),
  corners: PortalCorners(
    source: 12,
    destination: 20,
    style: .continuous
  )
)

// Without corner clipping
let simpleConfig = PortalTransitionConfig(
  animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
  // corners: nil (default) - no clipping applied
)
```

**iOS 17+ Enhanced Configuration:**

```swift
@available(iOS 17.0, *)
let advancedConfig = PortalTransitionConfig(
  animation: PortalAnimationWithCompletion(
    .smooth(duration: 0.5),
    delay: 0.1,
    completionCriteria: .logicallyComplete
  ),
  corners: PortalCorners(source: 12, destination: 20, style: .continuous)
)
```

**Configuration Parameters:**
- **`animation`**: Either `PortalAnimation` (iOS 15+) or `PortalAnimationWithCompletion` (iOS 17+)
- **`corners`**: Optional `PortalCorners` configuration
  - **When provided**: Clips views and transitions between source and destination corner radii
  - **When `nil` (default)**: No clipping is applied, allowing content to extend beyond frame boundaries during scaling transitions

**Animation Types:**
- **`PortalAnimation`**: iOS 15+ compatible, uses duration-based completion timing
- **`PortalAnimationWithCompletion`**: iOS 17+ only, uses modern completion criteria for precise control

Both types conform to `PortalAnimationProtocol` and work seamlessly with `PortalTransitionConfig`.

**iOS 17+ Enhanced Features:**
- Uses `@Observable` macro for efficient state management
- Supports `AnimationCompletionCriteria` for precise completion detection
- Leverages modern SwiftUI Environment system

**iOS 15+ Compatibility:**
- Falls back to `@ObservableObject` and `@EnvironmentObject`
- Uses duration-based completion timing
- Maintains full feature parity with legacy implementations

---

## Why It Works

- **AnchorPreferences** let you capture view positions without manual `GeometryReader` hacks
- A **separate overlay window** can float above sheets, navigation stacks, or any container
- The **floating layer** is an `AnyView`, so you can fly images, text, shapes, or fully custom SwiftUI views
- **Comprehensive configuration** through `PortalTransitionConfig` provides fine-tuned control over timing, styling, and behavior
- **Cross-iOS compatibility** ensures consistent behavior from iOS 15 to the latest versions
- **State management** through `CrossModel` coordinates all portal animations in a single shared model

In practice: you mark two views, configure your transition, flip a `Bool` or set an optional item, and watch your element seamlessly fly between them across any view boundary.

➡️ [Continue to Animations](./Animations)