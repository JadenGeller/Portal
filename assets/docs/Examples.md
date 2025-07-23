## Examples

### How Portal Differs from SwiftUI’s Matched Transitions

**Portal** and SwiftUI’s `matchedTransitionSource` / `navigationTransition` both enable animated transitions between views, but they serve different purposes and create distinct effects:

- **SwiftUI’s matched transitions** (`matchedTransitionSource`, `navigationTransition`):  
  Designed for zoom-style or morphing animations—think of an image smoothly transforming from a grid into a detail view.

- **Portal**:  
  Focuses on standard sheet or navigation-push transitions, with a shared element visually “travelling” between screens rather than just zooming or morphing.

https://github.com/user-attachments/assets/786db50e-dd67-495e-bdbb-3b70e1250c37

**In summary:**  
- Use SwiftUI’s matched transitions for zoom/morph effects between views.  
- Use Portal when you want a regular sheet or push, but with a shared element animating from one screen to another.  

_Check out the video for a side-by-side comparison of the effects!_

---

### Available Demos

All of these live under `Sources/Portal/Examples`:

- **SheetExample**  
  Demonstrates cross-view portal transitions in a sheet.

- **NavigationExample**  
  Shows portal transitions alongside `NavigationStack` pushes.

- **DifferExample**  
  Mixes Portal with iOS 18’s `matchedTransition` APIs to compare effects.