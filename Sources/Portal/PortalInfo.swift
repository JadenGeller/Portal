import SwiftUI

/// A data record that encapsulates all information needed for a single portal animation.
///
/// This struct serves as the central data model for tracking the complete state of a portal
/// transition between source and destination views. It contains positioning data, animation
/// configuration, state flags, and callback handlers needed to coordinate smooth transitions.
///
/// Each `PortalInfo` instance represents one unique portal animation identified by its `infoID`.
/// The struct tracks both the geometric information (anchors, progress) and behavioral aspects
/// (duration, visibility, completion handling) of the transition.
public struct PortalInfo: Identifiable {
    
    /// Unique identifier for SwiftUI's `Identifiable` protocol.
    ///
    /// This UUID is automatically generated and used by SwiftUI for efficient list updates
    /// and view identity tracking. It's separate from `infoID` which is the user-defined
    /// portal identifier.
    public let id = UUID()
    
    /// User-defined unique identifier for this portal animation.
    ///
    /// This string identifier is used to match source and destination views that should
    /// be connected by a portal transition. It should be unique within the scope of
    /// active portal animations.
    public let infoID: String
    
    /// Flag indicating whether this portal has been properly initialized.
    ///
    /// Set to `true` when the portal system has completed setup for this animation,
    /// including registering both source and destination views. Only initialized
    /// portals can begin their transition animations.
    public var initalized = false
    
    /// The intermediate view layer used during the portal transition animation.
    ///
    /// This view is displayed as an overlay during the transition, providing a smooth
    /// visual bridge between the source and destination views. It's typically a snapshot
    /// or representation of the transitioning content.
    public var layerView: AnyView? = nil
    
    /// Flag indicating whether the portal animation is currently active.
    ///
    /// When `true`, the portal transition is in progress. This affects opacity calculations
    /// and determines whether the intermediate layer view should be displayed.
    public var animateView = false
    
    /// Flag controlling the visibility of the destination view during animation.
    ///
    /// When `true`, the destination view is hidden (opacity 0), typically during the
    /// initial phase of the animation. When `false`, the destination view is visible,
    /// usually after the transition layer has completed its movement.
    public var hideView = false
    
    /// Anchor bounds information for the source (origin) view.
    ///
    /// Contains the geometric bounds of the source view in the coordinate space
    /// needed for calculating the starting position of the portal animation.
    /// Set when the source view reports its position through the preference system.
    public var sourceAnchor: Anchor<CGRect>? = nil
    
    /// Anchor bounds information for the destination (target) view.
    ///
    /// Contains the geometric bounds of the destination view in the coordinate space
    /// needed for calculating the ending position of the portal animation.
    /// Set when the destination view reports its position through the preference system.
    public var destinationAnchor: Anchor<CGRect>? = nil
    
    /// Completion callback executed when the portal animation finishes.
    ///
    /// This closure is called with a boolean parameter indicating whether the animation
    /// completed successfully (`true`) or was interrupted/cancelled (`false`).
    /// Default implementation is a no-op that ignores the completion status.
    public var completion: (Bool) -> Void = { _ in }
    
    /// Initializes a new PortalInfo instance with the specified identifier.
    ///
    /// Creates a new portal data record with default values for all properties
    /// except the required user-defined identifier.
    ///
    /// - Parameter id: The unique string identifier for this portal animation
    public init(id: String) {
        self.infoID = id
    }
}
