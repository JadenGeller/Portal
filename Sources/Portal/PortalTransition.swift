import SwiftUI

@available(iOS 15.0, macOS 13.0, *)
public struct OptionalPortalTransitionModifier<Item: Identifiable, LayerView: View>: ViewModifier {
    @Binding public var item: Item?
    
    public let config: PortalTransitionConfig
    
    public let layerView: (Item) -> LayerView
    public let completion: (Bool) -> Void
    
    @Environment(CrossModel.self) private var portalModel
    
    @State private var lastKey: String?
    
    public init(
        item: Binding<Item?>,
        config: PortalTransitionConfig,
        layerView: @escaping (Item) -> LayerView,
        completion: @escaping (Bool) -> Void
    ) {
        self._item = item
        self.config = config
        self.layerView = layerView
        self.completion = completion
    }
    
    private var key: String? {
        guard let value = item else { return nil }
        return "\(value.id)"
    }
    
    private func onChange(oldValue: Bool, hasValue: Bool) {
        
        guard let key = self.key, let unwrapped = item else { return }
        
        lastKey = key
        
        if portalModel.info.firstIndex(where: { $0.infoID == key }) == nil {
            portalModel.info.append(PortalInfo(id: key))
        }
        
        guard let idx = portalModel.info.firstIndex(where: { $0.infoID == key }) else { return }
        
        portalModel.info[idx].initalized = true
        portalModel.info[idx].animation = config.animation
        portalModel.info[idx].corners = config.corners
        portalModel.info[idx].completion = completion
        portalModel.info[idx].layerView = AnyView(layerView(unwrapped))
        
        
        if hasValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.animation.delay) {
                withAnimation(config.animation.value, completionCriteria: config.animation.completionCriteria) {
                    portalModel.info[idx].animateView = true
                } completion: {
                    portalModel.info[idx].hideView = true
                    portalModel.info[idx].completion(true)
                }
            }
        } else {
            portalModel.info[idx].hideView = false
            withAnimation(config.animation.value, completionCriteria: config.animation.completionCriteria) {
                portalModel.info[idx].animateView = false
            } completion: {
                portalModel.info[idx].initalized = false
                portalModel.info[idx].layerView = nil
                portalModel.info[idx].sourceAnchor = nil
                portalModel.info[idx].destinationAnchor = nil
                portalModel.info[idx].completion(false)
            }
            
            lastKey = nil
        }
    }
    
    public func body(content: Content) -> some View {
        content.onChange(of: item != nil, onChange)
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
    public let config: PortalTransitionConfig
    
    @Binding public var isActive: Bool
    
    public let layerView: () -> LayerView
    public let completion: (Bool) -> Void
    
    public init(
        id: String,
        config: PortalTransitionConfig,
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
        
        portalModel.info[idx].initalized = true
        portalModel.info[idx].animation = config.animation
        portalModel.info[idx].corners = config.corners
        portalModel.info[idx].completion = completion
        portalModel.info[idx].layerView = AnyView(layerView())
        
        if newValue {
            DispatchQueue.main.asyncAfter(deadline: .now() + config.animation.delay) {
                withAnimation(config.animation.value, completionCriteria: config.animation.completionCriteria) {
                    portalModel.info[idx].animateView = true
                } completion: {
                    portalModel.info[idx].hideView = true
                    portalModel.info[idx].completion(true)
                }
            }
            
        } else {
            portalModel.info[idx].hideView = false
            withAnimation(config.animation.value, completionCriteria: config.animation.completionCriteria) {
                portalModel.info[idx].animateView = false
            } completion: {
                portalModel.info[idx].initalized = false
                portalModel.info[idx].layerView = nil
                portalModel.info[idx].sourceAnchor = nil
                portalModel.info[idx].destinationAnchor = nil
                portalModel.info[idx].completion(false)
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
        config: PortalTransitionConfig = .init(),
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
        config: PortalTransitionConfig = .init(),
        @ViewBuilder layerView: @escaping (Item) -> LayerView,
        completion: @escaping (Bool) -> Void = { _ in }
    ) -> some View {
        self.modifier(
            OptionalPortalTransitionModifier(
                item: item,
                config: config,
                layerView: layerView,
                completion: completion
            )
        )
    }
}
