import SwiftUI

/// Comprehensive configuration container for portal transition animations.
///
/// This struct serves as the main configuration object that encapsulates all the settings
/// needed to customize a portal animation. It combines animation timing parameters with
/// visual styling options to provide complete control over the transition appearance.
///
/// The configuration is designed to be immutable and reusable across multiple portal
/// transitions, promoting consistency in animation behavior throughout an application.
///
/// **Usage Pattern:**
/// - Create once, use multiple times for consistent animations
/// - Pass to portal initialization or update methods
/// - Combine with different portal IDs for varied but consistent transitions
///
/// Example usage:
/// ```swift
/// let config = PortalTransitionConfig(
///     animation: PortalAnimation(.spring(duration: 0.5), delay: 0.1),
///     corners: PortalCorners(source: 8, destination: 16, style: .continuous)
/// )
///
/// // Use with portal animation
/// portalTransition(id: "myPortal", config: config)
/// ```
public struct PortalTransitionConfig {
    
    /// Animation timing and behavior configuration.
    ///
    /// Defines how the portal transition animates, including duration, easing curves,
    /// delays, and completion criteria. This controls the temporal aspects of the
    /// portal animation.
    public let animation: PortalAnimation
    
    /// Corner styling configuration for visual appearance.
    ///
    /// Defines the corner radius values and styling for both source and destination
    /// elements during the transition. This controls the spatial/visual aspects of
    /// the portal animation.
    public let corners: PortalCorners
    
    /// Initializes a new portal transition configuration.
    ///
    /// Creates a complete configuration object with specified animation and corner settings.
    /// Both parameters have sensible defaults, allowing for partial customization while
    /// maintaining good default behavior.
    ///
    /// - Parameters:
    ///   - animation: The animation configuration. Defaults to a smooth 0.3s animation.
    ///   - corners: The corner styling configuration. Defaults to no corner radius.
    public init(animation: PortalAnimation = .init(), corners: PortalCorners = .init()) {
        self.animation = animation
        self.corners = corners
    }
}

/// Animation configuration for portal transitions.
///
/// This struct encapsulates all timing-related parameters for portal animations,
/// including the SwiftUI animation curve, delay timing, and completion detection
/// criteria. It provides fine-grained control over the temporal behavior of
/// portal transitions.
///
/// **Key Features:**
/// - Wraps SwiftUI's `Animation` type for curve definitions
/// - Configurable delay for staggered animation effects
/// - Completion criteria for accurate animation lifecycle management
///
/// **Default Behavior:**
/// - Uses a smooth animation with slight bounce for natural feel
/// - Small delay to allow for view hierarchy updates
/// - Logical completion detection for reliable callback timing
public struct PortalAnimation {
    
    /// The SwiftUI animation curve and timing configuration.
    ///
    /// Defines the mathematical curve used for interpolating between animation
    /// keyframes. This includes duration, easing functions, and any special
    /// effects like spring physics or bounce.
    ///
    /// Common values:
    /// - `.smooth(duration: 0.3)` - Standard smooth transition
    /// - `.spring(duration: 0.5, bounce: 0.2)` - Physics-based spring
    /// - `.easeInOut(duration: 0.4)` - Classic ease-in-out curve
    public let value: Animation
    
    /// Delay before the animation begins, in seconds.
    ///
    /// This delay allows time for view hierarchy changes to settle before
    /// starting the portal animation. It's particularly important when the
    /// portal transition involves conditional view rendering or navigation
    /// changes that need time to complete.
    ///
    /// **Timing Considerations:**
    /// - Too short: Animation may start before views are properly positioned
    /// - Too long: Perceptible delay that feels unresponsive
    /// - Default 0.06s: Balance between reliability and responsiveness
    public let delay: TimeInterval
    
    /// Criteria for determining when the animation has completed.
    ///
    /// Defines how the portal system detects that the animation has finished,
    /// which triggers cleanup operations and completion callbacks. Different
    /// criteria may be appropriate for different types of animations.
    ///
    /// **Options:**
    /// - `.logicallyComplete`: Animation logic considers it finished
    /// - `.removed`: Animation is removed from the animation system
    /// - `.finished`: All animation values have reached their targets
    public let completionCriteria: AnimationCompletionCriteria
    
    /// Initializes a new portal animation configuration.
    ///
    /// Creates an animation configuration with specified timing parameters.
    /// The default values are carefully chosen to provide smooth, responsive
    /// animations that work well in most portal transition scenarios.
    ///
    /// - Parameters:
    ///   - animation: The SwiftUI animation curve. Defaults to smooth with slight bounce.
    ///   - delay: Start delay in seconds. Defaults to 0.06s for view settling.
    ///   - completionCriteria: How to detect completion. Defaults to logical completion.
    public init(
        _ animation: Animation = .smooth(duration: 0.3, extraBounce: 0.1),
        delay: TimeInterval = 0.06,
        completionCriteria: AnimationCompletionCriteria = .logicallyComplete,
    ) {
        self.value = animation
        self.delay = delay
        self.completionCriteria = completionCriteria
    }
}

/// Corner radius configuration for portal transition elements.
///
/// This struct defines the corner styling for both the source and destination
/// elements of a portal transition. It allows for smooth interpolation between
/// different corner radius values during the animation, creating visually
/// cohesive transitions even when source and destination have different styling.
///
/// **Corner Interpolation:**
/// During the transition, the corner radius is smoothly interpolated from the
/// source value to the destination value, ensuring visual continuity throughout
/// the animation.
///
/// **Style Consistency:**
/// The corner style (circular vs. continuous) is applied uniformly to maintain
/// visual consistency with the rest of the application's design language.
public struct PortalCorners {
    
    /// Corner radius for the source (starting) element, in points.
    ///
    /// This value defines the corner radius of the element at the beginning
    /// of the portal transition. The animation will start with this radius
    /// and interpolate toward the destination radius.
    ///
    /// A value of 0 creates sharp corners (rectangular appearance).
    public let source: CGFloat
    
    /// Corner radius for the destination (ending) element, in points.
    ///
    /// This value defines the corner radius of the element at the end
    /// of the portal transition. The animation will interpolate from the
    /// source radius to this target radius.
    ///
    /// A value of 0 creates sharp corners (rectangular appearance).
    public let destination: CGFloat
    
    /// The style of corner rounding to apply.
    ///
    /// Defines the mathematical curve used for creating rounded corners.
    /// This affects the visual appearance of the corners during the entire
    /// transition animation.
    ///
    /// **Available Styles:**
    /// - `.circular`: Traditional circular arc corners (iOS default)
    /// - `.continuous`: Apple's continuous corner curve (more organic appearance)
    public let style: RoundedCornerStyle
    
    /// Initializes a new portal corner configuration.
    ///
    /// Creates a corner configuration with specified radius values for source
    /// and destination elements, along with the corner style to use throughout
    /// the transition.
    ///
    /// - Parameters:
    ///   - source: Source corner radius in points. Defaults to 0 (sharp corners).
    ///   - destination: Destination corner radius in points. Defaults to 0 (sharp corners).
    ///   - style: Corner rounding style. Defaults to circular corners.
    public init(source: CGFloat = 0, destination: CGFloat = 0, style: RoundedCornerStyle = .circular) {
        self.source = source
        self.destination = destination
        self.style = style
    }
}
