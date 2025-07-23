## Examples

### How Portal Differs from SwiftUI's Matched Transitions

**Portal** and SwiftUI's `matchedTransitionSource` / `navigationTransition` both enable animated transitions between views, but they serve different purposes and create distinct effects:

- **SwiftUI's matched transitions** (`matchedTransitionSource`, `navigationTransition`):
  Designed for zoom-style or morphing animations—think of an image smoothly transforming from a grid into a detail view.

- **Portal**:
  Focuses on standard sheet or navigation-push transitions, with a shared element visually "travelling" between screens rather than just zooming or morphing.

https://github.com/user-attachments/assets/786db50e-dd67-495e-bdbb-3b70e1250c37

**In summary:**
- Use SwiftUI's matched transitions for zoom/morph effects between views.
- Use Portal when you want a regular sheet or push, but with a shared element animating from one screen to another.

_Check out the video for a side-by-side comparison of the effects!_

---

### Available Examples

All examples are available in the source code under `Sources/Portal/Examples/`:

- **`PortalExample_Comparison`**
  A real comparison showing Portal vs native iOS transitions side-by-side. Demonstrates Portal's cross-boundary capabilities compared to standard SwiftUI behavior. iOS 15+ compatible with conditional iOS 18 zoom transition support.

- **`PortalExample_StaticID`**
  Demonstrates Portal's static ID system with a code block that transitions seamlessly across sheet boundaries. Features a clean interface with syntax-highlighted code snippets and a card-based overview of Portal's capabilities.

- **`PortalExample_CardGrid`**
  Shows the item-based Portal API with a grid of colorful cards that open to detailed sheet views. Demonstrates automatic ID management, type-safe item binding using `Identifiable` objects, and corner styling with `PortalCorners`.

- **`AnimatedLayer`**
  A reusable component that provides visual feedback during portal transitions with scale animations. Used by the example views to enhance the transition experience with bounce effects.

---

### Key Example Patterns

#### Static ID Transitions (Static ID Example)

```swift
struct PortalExample_StaticID: View {
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            // Code block with Portal source
            CodeBlockView()
                .portal(id: "codeBlock", .source)
                .onTapGesture { showDetail.toggle() }
        }
        .sheet(isPresented: $showDetail) {
            DetailSheetView()
        }
        .portalTransition(
            id: "codeBlock",
            config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
            isActive: $showDetail
        ) {
            CodeBlockView()
        }
        .portalContainer()
    }
}
```

#### Item-Based Transitions (Card Grid Example)

```swift
struct PortalExample_CardGrid: View {
    @State private var selectedCard: PortalExample_Card? = nil
    let cards: [PortalExample_Card] = [...]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(cards) { card in
                CardView(card: card)
                    .portal(item: card, .source)
                    .onTapGesture { selectedCard = card }
            }
        }
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card)
        }
        .portalTransition(
            item: $selectedCard,
            config: .init(
                animation: PortalAnimation(.smooth(duration: 0.4, extraBounce: 0.1)),
                corners: PortalCorners(source: 16, destination: 20, style: .continuous)
            )
        ) { card in
            CardView(card: card)
        }
        .portalContainer()
    }
}
```

---

### Running the Examples

To run the examples in your own project:

1. Import the Portal package
2. Copy the example code from `Sources/Portal/Examples/`
3. Add the example views to your app's navigation or preview

```swift
#if DEBUG
import Portal

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Portal vs matchedGeometryEffect", destination: PortalExample_StaticID())
                NavigationLink("Card Grid with Items", destination: PortalExample_CardGrid())
            }
            .navigationTitle("Portal Examples")
        }
    }
}
#endif
```

---

### Best Practices from Examples

1. **Always wrap in `PortalContainer`** or use `.portalContainer()` extension
2. **Use consistent IDs** between source, destination, and transition
3. **Configure animations** through `PortalTransitionConfig` for consistent behavior
4. **Handle state properly** - use boolean bindings for simple cases, optional items for data-driven scenarios
5. **Test across iOS versions** - examples include both iOS 15+ and iOS 17+ patterns

---

For more detailed implementation examples, explore the source code in `Sources/Portal/Examples/`.