## How to Use Portal

Portal makes it easy to “teleport” views between hierarchies. Here are the two primary ways to drive transitions: using a boolean state (`isActive`) or using an optional identifiable item (`item`).

---

### Method 1: Using `isActive` (Boolean Trigger)

This method is suitable for transitions controlled by a simple on/off state, often involving a single source and destination pair identified by a static string ID.

**Steps:**

1.  **Wrap in `PortalContainer`:** Enclose the relevant view hierarchy.
2.  **Mark Source with ID:** Use `.portalSource(id:)` on the starting view, providing a unique string ID.
3.  **Mark Destination with ID:** Use `.portalDestination(id:)` on the target view, using the *same* string ID.
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
    .portalSource(id: portalID) // <-- Step 2: Use static ID
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
            .portalDestination(id: portalID) // <-- Step 3: Use matching static ID
    }
}
```

**4. Attach Transition:**

Use `.portalTransition(id:isActive:...)` specifying:
*   `id`: The static string identifier used in steps 2 & 3.
*   `isActive`: Your `Binding<Bool>` state variable.
*   `animation`, `animationDuration`, `delay`: Animation parameters.
*   `layerView`: A closure `() -> LayerView` defining the animating view.

```swift
// Applied to the VStack or another ancestor in ExampleBooleanView
.portalTransition(
    id: portalID, // <-- Step 4a: Use static ID
    isActive: $showSettingsSheet, // <-- Step 4b: Bind to Bool state
    animation: .smooth(duration: 0.5),
    animationDuration: 0.5
) { // <-- Step 4c: Define layer view (no arguments)
    Image(systemName: "gearshape.fill").font(.title)
}
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
                    .portalSource(id: portalID) // Step 2
                    .onTapGesture { showSettingsSheet = true }
                Spacer()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheetView(portalID: portalID) // Contains Step 3
            }
            .portalTransition( // Step 4
                id: portalID,
                isActive: $showSettingsSheet,
                animation: .smooth(duration: 0.5),
                animationDuration: 0.5
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
            .portalDestination(id: portalID) // Step 3
    }
}
```

---

### Method 2: Using `item` (Identifiable Trigger)

This method is ideal for data-driven transitions, especially list/grid -> detail scenarios. It uses an optional `Identifiable` item state to control the transition, automatically keying animations to the specific item's ID.

**Steps:**

1.  **Wrap in `PortalContainer`:** Enclose the relevant view hierarchy.
2.  **Mark Source with Item:** Use `.portalSource(item:)` on the starting view within your list/grid, passing the specific `Identifiable` item instance.
3.  **Mark Destination with Item:** Use `.portalDestination(item:)` on the target view (usually in the presented detail view), passing the corresponding `Identifiable` item instance.
4.  **Attach Transition with `item`:** Use `.portalTransition(item:...)` on an ancestor view, binding it to your `Binding<Optional<Item>>` state.

**Example Walkthrough (Based on Cards Example):**

**1. Wrap View Hierarchy:**

```swift
import SwiftUI
import Portal

// Define Identifiable Item
struct CardInfo: Identifiable { /* ... */ }

struct CardGridView: View {
    @State private var selectedCard: CardInfo? = nil // Optional Item state
    let cardData: [CardInfo] = [ /* ... */ ]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        PortalContainer { // <-- Step 1
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cardData) { card in
                        VStack(spacing: 12) {
                            // Source view goes here (Step 2)
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(/*...*/))
                                .frame(height: 120)
                            Text(card.title).font(.headline)
                        }
                        .onTapGesture { selectedCard = card } // Trigger state change
                    }
                }
                .padding()
            }
            .sheet(item: $selectedCard) { card in
                // Destination view goes here (Step 3)
                CardDetailView(card: card)
            }
            // Transition modifier goes here (Step 4)
        }
    }
}
```

**2. Mark Source:**

```swift
// Inside the ForEach loop in CardGridView
RoundedRectangle(cornerRadius: 16)
    .fill(LinearGradient(/*...*/))
    .frame(height: 120)
    .portalSource(item: card) // <-- Step 2: Pass the item
```

**3. Mark Destination:**

```swift
// Inside CardDetailView (presented by the sheet)
struct CardDetailView: View {
    let card: CardInfo
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(/*...*/))
                .frame(width: 240, height: 240)
                .portalDestination(item: card) // <-- Step 3: Pass the item
            Text(card.title).font(.title)
            Spacer()
        }
        .padding()
    }
}
```

**4. Attach Transition:**

Use `.portalTransition(item:...)` specifying:
*   `item`: Your `Binding<Optional<Item>>` state variable.
*   `animation`, `animationDuration`, `delay`: Animation parameters.
*   `layerView`: A closure `(Item) -> LayerView` that **receives the unwrapped item** and defines the animating view.

```swift
// Applied to the ScrollView or another ancestor in CardGridView
.portalTransition(
    item: $selectedCard, // <-- Step 4a: Bind to item state
    animation: .smooth(duration: 0.4, extraBounce: 0.1),
    animationDuration: 0.4
) { card in // <-- Step 4b: Closure receives item
    // Define layer view using the item
    RoundedRectangle(cornerRadius: 16)
        .fill(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
}
```

**Complete `item` Example:**

```swift
import SwiftUI
import Portal

// 1. Define Identifiable Item
struct CardInfo: Identifiable {
    let id = UUID()
    let title: String
    let gradientColors: [Color]
}

// 2. Define Detail View (Sheet Content)
struct CardDetailView: View {
    let card: CardInfo
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 240, height: 240)
                .portalDestination(item: card) // Step 3
            Text(card.title).font(.title)
            Spacer()
        }
        .padding()
    }
}

// 3. Define Main View
struct CardGridView: View {
    @State private var selectedCard: CardInfo? = nil
    let cardData: [CardInfo] = [ /* ... card data ... */ ]
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        PortalContainer { // Step 1
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cardData) { card in
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 120)
                                .portalSource(item: card) // Step 2
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
                animation: .smooth(duration: 0.4, extraBounce: 0.1),
                animationDuration: 0.4
            ) { card in
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
    }
}
```

---

👉 For full API docs, see the source code DocC comments.

➡️ [Continue to Examples / Wiki](link-to-examples-or-wiki)