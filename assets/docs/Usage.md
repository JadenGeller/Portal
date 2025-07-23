## How to Use Portal

Portal makes it easy to "teleport" views between hierarchies. Here are the two primary ways to drive transitions: using a boolean state (`isActive`) or using an optional identifiable item (`item`).

---

### Method 1: Using `isActive` (Boolean Trigger)

This method is suitable for transitions controlled by a simple on/off state, often involving a single source and destination pair identified by a static string ID.

**Steps:**

1.  **Wrap in `PortalContainer`:** Enclose the relevant view hierarchy.
2.  **Mark Source with ID:** Use `.portal(id:, .source)` on the starting view, providing a unique string ID.
3.  **Mark Destination with ID:** Use `.portal(id:, .destination)` on the target view, using the *same* string ID.
4.  **Attach Transition with `isActive`:** Use `.portalTransition(id:isActive:...)` on an ancestor view, binding it to your `Binding<Bool>` state and using the same string ID.

**Example Walkthrough:**

**1. Wrap View Hierarchy:**

```swift
import SwiftUI
import Portal

struct ExampleBooleanView: View {
    @State private var showSettingsSheet: Bool = false
    let portalID = "settingsIconTransition" // Define static ID

    var body: some View {
        PortalContainer { // <-- Wrap in PortalContainer (Step 1)
            VStack {
                // Source view goes here (Step 2)
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .onTapGesture { showSettingsSheet = true } // Trigger state change
                Spacer()
            }
            .sheet(isPresented: $showSettingsSheet) {
                // Destination view goes here (Step 3)
                SettingsSheetView(portalID: portalID)
            }
            // Transition modifier goes here (Step 4)
        }
    }
}
```

**2. Mark Source:**

```swift
Image(systemName: "gearshape.fill")
    .font(.title)
    .portal(id: portalID, .source) // <-- Step 2: Use static ID
    .onTapGesture { showSettingsSheet = true }
```

**3. Mark Destination:**

```swift
// Inside SettingsSheetView (presented by the sheet)
struct SettingsSheetView: View {
    let portalID: String
    var body: some View {
        Image(systemName: "gearshape.fill")
            .font(.title)
            .portal(id: portalID, .destination) // <-- Step 3: Use matching static ID
    }
}
```

**4. Attach Transition:**

Use `.portalTransition(id:isActive:...)` with `PortalTransitionConfig`:
*   `id`: The static string identifier used in steps 2 & 3.
*   `config`: A `PortalTransitionConfig` object containing animation and styling settings.
*   `isActive`: Your `Binding<Bool>` state variable.
*   `layerView`: A closure `() -> LayerView` defining the animating view.

```swift
// Applied to the VStack or another ancestor in ExampleBooleanView
.portalTransition(
    id: portalID, // <-- Step 4a: Use static ID
    config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
    isActive: $showSettingsSheet, // <-- Step 4b: Bind to Bool state
    layerView: { // <-- Step 4c: Define layer view (no arguments)
        Image(systemName: "gearshape.fill").font(.title)
    }
)
```

**Complete `isActive` Example:**

```swift
import SwiftUI
import Portal

struct ExampleBooleanView: View {
    @State private var showSettingsSheet: Bool = false
    let portalID = "settingsIconTransition" // Static ID

    var body: some View {
        PortalContainer { // Step 1
            VStack {
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .portal(id: portalID, .source) // Step 2: New unified API
                    .onTapGesture { showSettingsSheet = true }
                Spacer()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheetView(portalID: portalID) // Contains Step 3
            }
            .portalTransition( // Step 4
                id: portalID,
                config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
                isActive: $showSettingsSheet
            ) {
                Image(systemName: "gearshape.fill").font(.title)
            }
        }
    }
}

// Sheet Content View
struct SettingsSheetView: View {
    let portalID: String
    var body: some View {
        Image(systemName: "gearshape.fill")
            .font(.title)
            .portal(id: portalID, .destination) // Step 3: New unified API
    }
}
```

**Alternative: Using `.portalContainer()` Extension**

You can also use the convenient `.portalContainer()` extension instead of wrapping in `PortalContainer`:

```swift
struct ExampleBooleanView: View {
    @State private var showSettingsSheet: Bool = false
    let portalID = "settingsIconTransition"

    var body: some View {
        VStack {
            Image(systemName: "gearshape.fill")
                .font(.title)
                .portalSource(id: portalID)
                .onTapGesture { showSettingsSheet = true }
            Spacer()
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheetView(portalID: portalID)
        }
        .portalTransition(
            id: portalID,
            config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
            isActive: $showSettingsSheet
        ) {
            Image(systemName: "gearshape.fill").font(.title)
        }
        .portalContainer() // <-- Use extension method
    }
}
```

---

### Method 2: Using `item` (Identifiable Trigger)

This method is ideal for data-driven transitions, especially list/grid -> detail scenarios. It uses an optional `Identifiable` item state to control the transition, automatically keying animations to the specific item's ID.

**Steps:**

1.  **Wrap in `PortalContainer`:** Enclose the relevant view hierarchy.
2.  **Mark Source with Item:** Use `.portal(item:, .source)` on the starting view within your list/grid, passing the specific `Identifiable` item instance.
3.  **Mark Destination with Item:** Use `.portal(item:, .destination)` on the target view (usually in the presented detail view), passing the corresponding `Identifiable` item instance.
4.  **Attach Transition with `item`:** Use `.portalTransition(item:...)` on an ancestor view, binding it to your `Binding<Optional<Item>>` state.

**Example Walkthrough:**

**1. Define Identifiable Item:**

```swift
struct CardInfo: Identifiable {
    let id = UUID()
    let title: String
    let gradientColors: [Color]
}
```

**2. Complete `item` Example:**

```swift
import SwiftUI
import Portal

struct CardGridView: View {
    @State private var selectedCard: CardInfo? = nil
    let cardData: [CardInfo] = [
        CardInfo(title: "Card 1", gradientColors: [.blue, .purple]),
        CardInfo(title: "Card 2", gradientColors: [.red, .orange]),
        // ... more cards
    ]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(cardData) { card in
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: card.gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 120)
                            .portal(item: card, .source) // Step 2: New unified API
                        Text(card.title).font(.headline)
                    }
                    .padding(.bottom, 12)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                    .onTapGesture { selectedCard = card }
                }
            }
            .padding()
        }
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card) // Contains Step 3
        }
        .portalTransition( // Step 4
            item: $selectedCard,
            config: .init(animation: PortalAnimation(.smooth(duration: 0.4, extraBounce: 0.1)))
        ) { card in // <-- Closure receives item
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    gradient: Gradient(colors: card.gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        }
        .portalContainer() // Step 1: Wrap in portal container
    }
}

// Detail View (Sheet Content)
struct CardDetailView: View {
    let card: CardInfo
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    gradient: Gradient(colors: card.gradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 240, height: 240)
                .portalDestination(item: card) // Step 3: Pass the item
            Text(card.title).font(.title)
            Spacer()
        }
        .padding()
    }
}
```

---

### Advanced Configuration with `PortalTransitionConfig`

Portal provides comprehensive configuration through `PortalTransitionConfig`. The config accepts either `PortalAnimation` (iOS 15+) or `PortalAnimationWithCompletion` (iOS 17+) for the animation parameter:

**Basic Configuration (iOS 15+):**

```swift
// Configuration with corner clipping
let config = PortalTransitionConfig(
    animation: PortalAnimation(
        .spring(response: 0.5, dampingFraction: 0.8),
        delay: 0.1,
        duration: 0.5
    ),
    corners: PortalCorners(
        source: 8,
        destination: 16,
        style: .continuous
    )
)

// Configuration without corner clipping
let simpleConfig = PortalTransitionConfig(
    animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))
    // corners: nil (default) - no clipping applied
)

// Use with any portal transition
.portalTransition(id: "myPortal", config: config, isActive: $isActive) {
    MyLayerView()
}
```

**iOS 17+ Enhanced Configuration:**

For iOS 17+, you can use `PortalAnimationWithCompletion` for more precise animation control:

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
  - **When `nil` (default)**: No clipping is applied, content can extend beyond frame boundaries

**Animation Type Summary:**
- **`PortalAnimation`**: Works on iOS 15+, uses duration-based completion timing
- **`PortalAnimationWithCompletion`**: iOS 17+ only, uses modern completion criteria for precise control

Both animation types conform to `PortalAnimationProtocol` and can be used interchangeably in `PortalTransitionConfig`.

---

👉 For full API documentation, see the source code DocC comments.

➡️ [Continue to Examples](./Examples)