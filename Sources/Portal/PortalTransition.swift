import SwiftUI

@available(iOS 15.0, macOS 13.0, *)
public struct OptionalPortalTransitionModifier<Item: Identifiable, LayerView: View>: ViewModifier {
    @Binding public var item: Item?
    public let sourceProgress: CGFloat
    public let destinationProgress: CGFloat
    public let animation: Animation
    public let animationDuration: TimeInterval
    public let delay: TimeInterval
    public let layerView: (Item) -> LayerView
    public let completion: (Bool) -> Void

    @Environment(CrossModel.self) private var portalModel

    /// Compute a unique key from the item's `id`
    private var key: String? {
        guard let value = item else { return nil }
        return "\(value.id)"
    }
    /// Keep the last‐used string key so deactivation can find the exact entry.
    @State private var lastKey: String?

    public init(
        item: Binding<Item?>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .bouncy(duration: 0.3),
        animationDuration: TimeInterval = 0.3,
        delay: TimeInterval = 0.06,
        layerView: @escaping (Item) -> LayerView,
        completion: @escaping (Bool) -> Void = { _ in }
    ) {
        self._item = item
        self.sourceProgress = sourceProgress
        self.destinationProgress = destinationProgress
        self.animation = animation
        self.animationDuration = animationDuration
        self.delay = delay
        self.layerView = layerView
        self.completion = completion
    }

    public func body(content: Content) -> some View {
        content
//             React only when `item` changes from nil→non‑nil or vice versa
            .onChange(of: item != nil) { oldValue, hasValue in
                        if hasValue {
                            print("item active")
                            // item just became non‑nil → activate
                            guard let key = self.key, let unwrapped = item else { return }
                            // remember exact key for later
                            lastKey = key
                            // register once
                            if portalModel.info.firstIndex(where: { $0.infoID == key }) == nil {
                                print("reigsterd")
                                portalModel.info.append(PortalInfo(id: key))
                            }
                            guard let idx = portalModel.info.firstIndex(where: { $0.infoID == key }) else { return }
                            print("configuring..")
                            // configure
                            portalModel.info[idx].initalized = true
                            portalModel.info[idx].completion         = completion
                            portalModel.info[idx].layerView          = AnyView(layerView(unwrapped))
                            // fire the animation
                            print("animating..")
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                withAnimation(animation) {
                                    portalModel.info[idx].animateView = true
                                }
                            }
                        } else {
                            guard let key = lastKey,
                            let idx = portalModel.info.firstIndex(where: { $0.infoID == key })
                            else { return }
                            portalModel.info[idx].hideView = false
                            withAnimation(animation) {
                                portalModel.info[idx].animateView = false
                            }
                            lastKey = nil
                        }
                    }
    }
}


/// Drives the Portal floating layer for a given id.
///
/// Use this view modifier to trigger and control a portal transition animation between
/// a source and destination view. The modifier manages the floating overlay layer,
/// animation timing, and transition state for the specified `id`.
///
/// - Parameters:
///   - id: A unique string identifier for the portal transition. This should match the `id` used for the corresponding portal source and destination.
///   - isActive: A binding that triggers the transition when set to `true`.
///   - sourceProgress: The progress value for the source view (default: 0).
///   - destinationProgress: The progress value for the destination view (default: 0).
///   - animation: The animation to use for the transition (default: `.bouncy(duration: 0.3)`).
///   - animationDuration: The duration of the transition animation (default: 0.3).
///   - delay: The delay before starting the animation (default: 0.06).
///   - layer: A closure that returns the floating overlay view to animate.
///   - completion: A closure called when the transition completes, with a `Bool` indicating success.
///
/// Example usage (Toggling visibility):
/// ```swift
/// struct ProfileView: View {
///     @State private var showEnlargedAvatar: Bool = false
///     let portalID = "avatarTransition"
///
///     var body: some View {
///         // 1. Wrap in PortalContainer
///         PortalContainer {
///             VStack {
///                 // 2. Source View
///                 Image("avatar-small")
///                     .resizable()
///                     .frame(width: 50, height: 50)
///                     .clipShape(Circle())
///                     .portalSource(id: portalID) // Mark source
///                     .onTapGesture {
///                         showEnlargedAvatar = true // Activate transition
///                     }
///
///                 Spacer() // Layout space
///
///                 // 3. Destination View (conditionally shown)
///                 if showEnlargedAvatar {
///                     Image("avatar-large") // Could be the same image name
///                         .resizable()
///                         .frame(width: 200, height: 200)
///                         .clipShape(Circle())
///                         .portalDestination(id: portalID) // Mark destination
///                         .onTapGesture {
///                             showEnlargedAvatar = false // Deactivate transition
///                         }
///                 } else {
///                     // Placeholder to maintain layout if needed
///                     Circle().fill(Color.clear).frame(width: 200, height: 200)
///                 }
///
///                 Spacer() // Layout space
///             }
///             .padding()
///             // 4. Apply the transition modifier
///             .portalTransition(
///                 id: portalID,               // Same ID
///                 isActive: $showEnlargedAvatar, // Boolean binding
///                 animation: .smooth(duration: 0.5),
///                 animationDuration: 0.5
///             ) {
///                 // 5. Define the floating layer (what animates)
///                 Image("avatar-small") // Or "avatar-large"
///                     .resizable()
///                     .aspectRatio(contentMode: .fill) // Ensure it fills during transition
///                     .clipShape(Circle()) // Match styling
///             }
///         }
///     }
/// }
/// ```
@available(iOS 15.0, macOS 13.0, *)
internal struct ConditionalPortalTransitionModifier<LayerView: View>: ViewModifier {
    @Environment(CrossModel.self) private var portalModel
    
    public let id: String
    public let config: PortalAnimationConfig
    
    @Binding public var isActive: Bool
    
    public let layerView: () -> LayerView
    public let completion: (Bool) -> Void
    
    public init(
        id: String,
        config: PortalAnimationConfig,
        isActive: Binding<Bool>,
        layerView: @escaping () -> LayerView,
        completion: @escaping (Bool) -> Void
    ) {
        self.id = id
        self.config = config
        self._isActive = isActive
        self.layerView = layerView
        self.completion = completion
    }
    
    private func onAppear() {
        if !portalModel.info.contains(where: { $0.infoID == id }) {
            portalModel.info.append(PortalInfo(id: id))
        }
    }
    
    private func onChange(oldValue: Bool, newValue: Bool) {
        guard let idx = portalModel.info.firstIndex(where: { $0.infoID == id }) else { return }
        
        var portalInfoArray: [PortalInfo] {
            get { portalModel.info }
            set { portalModel.info = newValue }
        }
        
        portalInfoArray[idx].initalized = true
        portalInfoArray[idx].completion = completion
        portalInfoArray[idx].layerView = AnyView(layerView())
        
        if newValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.source.delay) {
                withAnimation(config.source.animation, completionCriteria: config.source.completionCriteria) {
                    portalInfoArray[idx].animateView = true
                } completion: {
                    portalInfoArray[idx].hideView = true
                    portalInfoArray[idx].completion(true)
                    config.source.completion()
                }
            }
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.destination.delay)  {
                portalInfoArray[idx].hideView = false
                withAnimation(config.destination.animation, completionCriteria: config.destination.completionCriteria) {
                    portalInfoArray[idx].animateView = false
                } completion: {
                    portalInfoArray[idx].initalized = false
                    portalInfoArray[idx].layerView = nil
                    portalInfoArray[idx].sourceAnchor = nil
                    portalInfoArray[idx].destinationAnchor = nil
                    portalInfoArray[idx].completion(false)
                    config.destination.completion()
                }
            }
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear(perform: onAppear)
            .onChange(of: isActive, onChange)
    }
}

public extension View {
    func portalTransition<LayerView: View>(
        id: String,
        config: PortalAnimationConfig = .init(),
        isActive: Binding<Bool>,
        @ViewBuilder layerView: @escaping () -> LayerView,
        completion: @escaping (Bool) -> Void = { _ in }
    ) -> some View {
        self.modifier(
            ConditionalPortalTransitionModifier(
                id: id,
                config: config,
                isActive: isActive,
                layerView: layerView,
                completion: completion))
    }
    
    func portalTransition<Item: Identifiable, LayerView: View>(
        item: Binding<Optional<Item>>,
        sourceProgress: CGFloat = 0,
        destinationProgress: CGFloat = 0,
        animation: Animation = .smooth(duration: 0.42, extraBounce: 0.2),
        animationDuration: TimeInterval = 0.72,
        delay: TimeInterval = 0.06,
        @ViewBuilder layerView: @escaping (Item) -> LayerView,
        completion: @escaping (Bool) -> Void = { _ in }
    ) -> some View {
        self.modifier(
            OptionalPortalTransitionModifier(
                item: item,
                sourceProgress: sourceProgress,
                destinationProgress: destinationProgress,
                animation: animation,
                animationDuration: animationDuration,
                delay: delay,
                layerView: layerView,
                completion: completion
            )
        )
    }
}
