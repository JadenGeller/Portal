import SwiftUI

// MARK: - iOS 17+ Implementation

/// Shared model for managing Portal animations and transitions.
///
/// This class serves as the central coordinator for portal animations, managing the state
/// and anchor information for both source and destination views. It tracks animation states,
/// opacity values, and coordinate transformations needed for smooth portal transitions.
///
/// The model uses the `@Observable` macro for SwiftUI integration and is marked with
/// `@MainActor` to ensure all UI-related operations happen on the main thread.
@available(iOS 17.0, *)
@MainActor @Observable
public class CrossModel {
    /// Array containing information about all active portal animations.
    /// Each `PortalInfo` object tracks the state of a specific portal transition.
    public var info: [PortalInfo] = []
    
    /// Array containing root-level portal information.
    /// Used for managing portal hierarchies and nested portal scenarios.
    public var rootInfo: [PortalInfo] = []
    
    /// Initializes a new CrossModel instance.
    /// Creates empty arrays for managing portal information.
    public init() {}
}

// MARK: - iOS 15+ Fallback Implementation

/// iOS 15 compatible version of CrossModel using ObservableObject.
///
/// This fallback implementation provides the same functionality as the iOS 17 version
/// but uses the traditional ObservableObject pattern for compatibility with earlier iOS versions.
///
/// - Warning: This implementation is deprecated and will be removed in a future version.
///   Use the iOS 17+ version when possible.
@available(iOS, introduced: 15.0, deprecated: 17.0, message: "Use the iOS 17+ version when possible")
@MainActor
public class CrossModelLegacy: ObservableObject {
    /// Array containing information about all active portal animations.
    /// Each `PortalInfo` object tracks the state of a specific portal transition.
    @Published public var info: [PortalInfo] = []
    
    /// Array containing root-level portal information.
    /// Used for managing portal hierarchies and nested portal scenarios.
    @Published public var rootInfo: [PortalInfo] = []
    
    /// Initializes a new CrossModelLegacy instance.
    /// Creates empty arrays for managing portal information.
    public init() {}
}


