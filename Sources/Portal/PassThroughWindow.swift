#if canImport(UIKit)
import UIKit
import SwiftUI

/// A window that lets touches pass through non-content areas
internal class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event), let rootView = rootViewController?.view else { return nil }
        // If the hit is on the root view controller's background, pass it through
        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                let pointInSubView = subview.convert(point, from: rootView)

                if subview.hitTest(pointInSubView, with: event) != nil {
                    return hitView
                }
            }
        }
        
        return hitView == rootView ? nil : hitView
    }
}
#else
import SwiftUI

/// Stub for non-UIKit platforms
internal class PassThroughWindow { }
#endif
