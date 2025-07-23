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

#### iOS 15+ Compatible Examples

- **`BasicSheetExample`**
  Demonstrates a simple portal transition between a main view and a sheet presentation. Shows how to use `.portalSource()`, `.portalDestination()`, and `.portalTransition()` with boolean state control.

- **`BasicNavigationExample`**
  Shows portal transitions during navigation pushes using `NavigationView`. Demonstrates how Portal works across navigation boundaries where traditional `matchedGeometryEffect` cannot.

- **`MultiplePortalsExample`**
  Illustrates managing multiple portal transitions within the same view hierarchy, each with unique IDs and configurations.

#### iOS 17+ Enhanced Examples

- **`ClipShapeExample`**
  Demonstrates advanced corner styling and clipping effects using `PortalCorners` configuration.

- **`ComparisonExample`**
  Side-by-side comparison of Portal transitions vs. SwiftUI's built-in matched transitions, highlighting the differences in behavior and use cases.

- **`CompletionCriteriaExample`**
  Shows how to use iOS 17+ completion criteria for precise animation lifecycle control with `PortalAnimationWithCompletion`.

---

### Key Example Patterns

#### Basic Sheet Transition

```swift
struct BasicSheetExample: View {
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 200, height: 120)
                .portalSource(id: "heroCard")
                .onTapGesture { showDetail.toggle() }
        }
        .sheet(isPresented: $showDetail) {
            DetailSheetView()
        }
        .portalTransition(
            id: "heroCard",
            config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
            isActive: $showDetail
        ) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .portalContainer()
    }
}
```

#### Data-Driven Transitions

```swift
struct CardGridExample: View {
    @State private var selectedCard: Card? = nil
    let cards: [Card] = [...]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(cards) { card in
                CardView(card: card)
                    .portalSource(item: card)
                    .onTapGesture { selectedCard = card }
            }
        }
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card)
        }
        .portalTransition(item: $selectedCard) { card in
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
                NavigationLink("Basic Sheet", destination: BasicSheetExample())
                NavigationLink("Basic Navigation", destination: BasicNavigationExample())
                NavigationLink("Multiple Portals", destination: MultiplePortalsExample())
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