# Portal

**Portal** is a SwiftUI package for seamless element transitions between views—including across sheets and navigation pushes (`NavigationStack`, `.navigationDestination`, etc)—using a portal metaphor for maximum flexibility.

- **Effortless transitions:** Move elements smoothly between views, even across navigation boundaries.
- **Flexible:** Works with sheets, navigation stacks, and custom containers.
- **Modern:** Built for SwiftUI, compatible with iOS 15.0 and later.
- **iOS 17 Optimized:** Takes advantage of modern SwiftUI features like Environment values and completion criteria.

---

## 🚀 Key Features

- **`PortalContainer { ... }`** - Manages the overlay window logic required for floating portal animations across hierarchies.
- **`.portalContainer()`** - View extension for easily wrapping any view hierarchy in a `PortalContainer`.
- **`.portalSource(id:)` & `.portalSource(item:)`** - Mark views as source anchors using string IDs or `Identifiable` items.
- **`.portalDestination(id:)` & `.portalDestination(item:)`** - Mark views as destination anchors.
- **`.portalTransition(id: isActive: ...)` & `.portalTransition(item: ...)`** - Drive transitions with boolean bindings or optional `Identifiable` items.
- **`PortalTransitionConfig`** - Comprehensive configuration for animations, timing, and corner styling.
- **iOS 15+ Compatible** - Maintains backward compatibility with fallback implementations.

---

## 🚀 Get Started

- [How to Install](./How-to-Install)
- [Usage](./Usage)
- [Examples](./Examples)
- [How Portal Works](./How-Portal-Works)
- [Animations](./Animations)

---

## Why Portal?

Traditional SwiftUI transitions are limited to a single view hierarchy. **Portal** lets you "teleport" elements between views, maintaining visual continuity—perfect for delightful, user-centered UI flows.

- **No hacks:** Clean, idiomatic SwiftUI.
- **Maximum creative freedom:** Design transitions that feel magical, not mechanical.
- **Cross-hierarchy support:** Works across sheets, navigation, and any view boundaries.

---

## Explore More

- [How to Install](./How-to-Install): Add Portal to your project.
- [Usage](./Usage): Core concepts and API.
- [Examples](./Examples): Real-world patterns and inspiration.
- [Animations](./Animations): Customizing transitions for maximum delight.

---

**Portal** is built for designers and developers who want to push SwiftUI beyond the ordinary.
Questions, ideas, or want to contribute? [Open an issue](https://github.com/aeastr/portal/issues) or join the discussion!

---

Build seamless, magical transitions. Build with Portal.