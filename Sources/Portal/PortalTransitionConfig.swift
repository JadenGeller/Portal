import SwiftUI

public struct PortalTransitionConfig {
    
    public let animation: PortalAnimation
    public let corners: PortalCorners
    
    public init(animation: PortalAnimation = .init(), corners: PortalCorners = .init()) {
        self.animation = animation
        self.corners = corners
    }
}

public struct PortalAnimation {
    public let value: Animation
    public let delay: TimeInterval
    public let completionCriteria: AnimationCompletionCriteria
    
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

public struct PortalCorners {
    public let source: CGFloat
    public let destination: CGFloat
    
    public let style: RoundedCornerStyle
    
    public init(source: CGFloat = 0, destination: CGFloat = 0, style: RoundedCornerStyle = .circular) {
        self.source = source
        self.destination = destination
        self.style = style
    }
}
