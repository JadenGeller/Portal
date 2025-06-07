import SwiftUI

/// A unified view wrapper that marks its content as either a portal source (leaving view) or destination (arriving view).
///
/// This struct consolidates the functionality of both `PortalSource` and `PortalDestination` into a single,
/// more efficient implementation. Used internally by the `.portalSource(id:)` and `.portalDestination(id:)`
/// view modifiers to identify the source or destination of a portal transition animation.
///
/// - Parameters:
///   - id: A unique string identifier for this portal. This should match the `id` used for the corresponding portal transition.
///   - source: A boolean flag indicating whether this is a source (true) or destination (false) portal.
///   - content: The view content to be marked as the portal.
public struct Portal<Content: View>: View {
    private let id: String
    private let source: Bool
    @ViewBuilder private let content: Content
    @Environment(CrossModel.self) private var portalModel
    
    /// Initializes a new Portal view.
    ///
    /// - Parameters:
    ///   - id: A unique string identifier for this portal
    ///   - source: Whether this portal acts as a source (true) or destination (false). Defaults to true.
    ///   - content: A view builder closure that returns the content to be wrapped
    public init(id: String, source: Bool = true, @ViewBuilder content: () -> Content) {
        self.id = id
        self.source = source
        self.content = content()
    }
    
    /// Transforms anchor preferences for this portal.
    ///
    /// - Parameter anchor: The anchor bounds to transform
    /// - Returns: A dictionary mapping portal IDs to their anchor bounds
    private func anchorPreferenceTransform(anchor: Anchor<CGRect>) -> [String: Anchor<CGRect>] {
        portalModel.anchorPreferenceTransform(for: id, source: source, anchor: anchor)
    }
    
    /// Handles preference changes for this portal.
    ///
    /// - Parameter prefs: The updated preference dictionary containing anchor bounds
    private func preferenceChangePerform(prefs: [String: Anchor<CGRect>]) {
        portalModel.preferenceChangePerform(for: id, source: source, prefs: prefs)
    }
    
    public var body: some View {
        content
            .opacity(portalModel.getOpacity(for: id, source: source))
            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: anchorPreferenceTransform)
            .onPreferenceChange(AnchorKey.self, perform: preferenceChangePerform)
    }
}

// MARK: - View Extensions

public extension View {
    /// Marks this view as a portal source (leaving view).
    ///
    /// Attach this modifier to the view that should act as the source for a portal transition.
    /// The source view is typically the element that the user interacts with to initiate the transition.
    ///
    /// - Parameter id: A unique string identifier for this portal source. This should match the `id`
    ///   used for the corresponding portal destination and transition.
    ///
    /// Example usage:
    /// ```swift
    /// Image("cover")
    ///     .portalSource(id: "Book1")
    /// ```
    func portalSource(id: String) -> some View {
        Portal(id: id, source: true) { self }
    }
    
    /// Marks this view as a portal destination (arriving view).
    ///
    /// Attach this modifier to the view that should act as the destination for a portal transition.
    /// The destination view is typically the element that appears after the transition completes.
    ///
    /// - Parameter id: A unique string identifier for this portal destination. This should match the `id`
    ///   used for the corresponding portal source and transition.
    ///
    /// Example usage:
    /// ```swift
    /// Image("cover")
    ///     .portalDestination(id: "Book1")
    /// ```
    func portalDestination(id: String) -> some View {
        Portal(id: id, source: false) { self }
    }
}
