import SwiftUI

/// Shared model for Portal animations
@MainActor @Observable
public class CrossModel {
    public var info: [PortalInfo] = []
    public var rootInfo: [PortalInfo] = []
    public init() {}
}
