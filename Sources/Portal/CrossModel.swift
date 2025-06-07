import SwiftUI

/// Shared model for managing Portal animations and transitions.
///
/// This class serves as the central coordinator for portal animations, managing the state
/// and anchor information for both source and destination views. It tracks animation states,
/// opacity values, and coordinate transformations needed for smooth portal transitions.
///
/// The model uses the `@Observable` macro for SwiftUI integration and is marked with
/// `@MainActor` to ensure all UI-related operations happen on the main thread.
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
    
    /// Checks if a portal animation is currently active for the given identifier.
    ///
    /// - Parameter key: The unique identifier for the portal
    /// - Returns: `true` if the portal animation is active, `false` otherwise
    public func isActive(for key: String) -> Bool {
        let idx = info.firstIndex(where: { $0.infoID == key })
        return idx.flatMap { info[$0].animateView } ?? false
    }
    
    /// Calculates the opacity value for a portal view based on its current state.
    ///
    /// This method determines whether a source or destination view should be visible
    /// during different phases of the portal animation.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the portal
    ///   - source: `true` for source views, `false` for destination views
    /// - Returns: The opacity value (0.0 to 1.0) for the view
    public func getOpacity(for id: String, source: Bool) -> CGFloat {
        guard let idx = getIndex(for: id) else { return 1 }
        
        if source {
            // Source view: hide when destination anchor is available (transition started)
            return info[idx].destinationAnchor == nil ? 1 : 0
        } else {
            // Destination view: show/hide based on initialization and animation state
            return info[idx].initalized ? (info[idx].hideView ? 1 : 0) : 1
        }
    }
    
    /// Finds the index of portal information for the given identifier.
    ///
    /// - Parameter id: The unique identifier for the portal
    /// - Returns: The index in the `info` array, or `nil` if not found
    private func getIndex(for id: String) -> Int? {
        info.firstIndex { $0.infoID == id }
    }
    
    /// Generates a unique key for anchor preference storage.
    ///
    /// Creates distinct keys for source and destination views to avoid conflicts
    /// when storing anchor preferences in the same dictionary.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the portal
    ///   - source: `true` for source views, `false` for destination views
    /// - Returns: A unique key string for the anchor preference
    private func getKey(for id: String, source: Bool) -> String {
        source ? id : "\(id)DEST"
    }
    
    /// Transforms anchor preferences for SwiftUI's preference system.
    ///
    /// This method is called by SwiftUI's anchor preference mechanism to collect
    /// the bounds information of portal views. It only processes anchors for
    /// initialized portals to avoid unnecessary work.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the portal
    ///   - source: `true` for source views, `false` for destination views
    ///   - anchor: The anchor bounds provided by SwiftUI
    /// - Returns: A dictionary mapping the portal key to its anchor, or empty if not ready
    func anchorPreferenceTransform(for id: String, source: Bool, anchor: Anchor<CGRect>) -> [String: Anchor<CGRect>] {
        var result: [String: Anchor<CGRect>] = [:]
        MainActor.assumeIsolated {
            if let idx = getIndex(for: id), info[idx].initalized {
                result = [getKey(for: id, source: source): anchor]
            }
        }
        return result
    }
    
    /// Handles preference changes from SwiftUI's anchor preference system.
    ///
    /// This method is called when anchor preferences change, typically when views
    /// are laid out or repositioned. It stores the source anchor information needed
    /// for calculating portal transitions.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the portal
    ///   - source: `true` for source views, `false` for destination views
    ///   - prefs: Dictionary containing the updated anchor preferences
    func preferenceChangePerform(for id: String, source: Bool, prefs: [String: Anchor<CGRect>]) {
        MainActor.assumeIsolated {
            if let idx = getIndex(for: id),
               info[idx].initalized,
               info[idx].sourceAnchor == nil {
                info[idx].sourceAnchor = prefs[getKey(for: id, source: source)]
            }
        }
    }
}
