Portal’s “magic” comes from decoupling your source and destination views and rendering the transition in a lightweight overlay window.

### 1. Set Up the Overlay  
Wrap your root view in a `PortalContainer`:

```swift
PortalContainer {
  // … your app’s root content …
}
```

Under the hood, PortalContainer:

- Installs a transparent, non-blocking `UIWindow` above your normal hierarchy  
- Hosts a single `PortalLayerView` that renders all floating layers during transitions  

![Architecture](https://github.com/user-attachments/assets/998eaf85-598e-4b13-8f1c-8890f5d7aa8f)

---

### 2. Mark Your Views  
Tell Portal which two views to animate:

```swift
// The “leaving” view
.portalSource(id: "X")

// The “arriving” view
.portalDestination(id: "X")
```

Behind the scenes, each modifier:

- Captures its view’s bounding rectangle via an `AnchorPreference`  
- Stores that geometry in a shared lookup keyed by your `id`  

![Source & Destination Capture](https://github.com/user-attachments/assets/6113ccb6-c6a8-4dc4-a5a9-f9a8e1ca25b0)

---

### 3. Trigger the Transition  
On the view that presents your detail (sheet, push, etc.), attach:

```swift
.portalTransition(
  id:       "X",                // matches your source/destination
  animate:  $isShowingDetail,   // Binding<Bool> drives the animation
  animation:         .smooth(duration: 0.6),
  animationDuration: 0.6,       // total duration for timing
  delay:             0.1        // optional
) {
  // The floating layer shown during the animation
  MyFloatingView()
}
```

![portalTransition](https://github.com/user-attachments/assets/4299f10f-5216-4721-934a-5e3e22353263)

- Flipping `animate` to `true` moves the overlay from source → destination  
- Flipping it back reverses the animation  
- The overlay is only visible during the transition; original views are restored afterward  

![Portal Transition Flow](https://github.com/user-attachments/assets/db772732-37ed-4418-a770-38e2cd18d912)

---

## Why It Works

- **AnchorPreferences** let you capture view positions without manual `GeometryReader` hacks  
- A **separate overlay window** can float above sheets, navigation stacks, or any container  
- The **floating layer** is an `AnyView`, so you can fly images, text, shapes, or fully custom SwiftUI views  
- **Animation** and **delay** parameters give you fine-tuned control over timing  

In practice: you mark two views, flip a `Bool`, and watch your element seamlessly fly between them.comes from decoupling your source and destination views and rendering the transition in a lightweight overlay window.

➡️ [Continue to Animations](./Animations)