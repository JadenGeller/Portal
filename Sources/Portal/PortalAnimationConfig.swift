import SwiftUI

public struct PortalAnimationConfig {
    
    public let source: PortalAnimation
    public let destination: PortalAnimation
    
    public init(animation: PortalAnimation = .init()) {
        self.source = animation
        self.destination = animation
    }
    
    public init(source: PortalAnimation, destination: PortalAnimation) {
        self.source = source
        self.destination = destination
    }
}

public struct PortalAnimation {
    public let animation: Animation
    public let delay: TimeInterval
    public let completionCriteria: AnimationCompletionCriteria
    public let completion: () -> Void
    
    public init(
        _ animation: Animation = .smooth(duration: 0.3, extraBounce: 0.1),
        delay: TimeInterval = 0.06,
        completionCriteria: AnimationCompletionCriteria = .logicallyComplete,
        completion: @escaping () -> Void = {}
    ) {
        self.animation = animation
        self.delay = delay
        self.completionCriteria = completionCriteria
        self.completion = completion
    }
}
