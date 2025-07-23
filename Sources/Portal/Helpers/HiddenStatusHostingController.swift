import SwiftUI
#if canImport(UIKit)
import UIKit

/// A HostingController that always hides the status bar.
final class HiddenStatusHostingController<Content: View>: UIHostingController<Content> {
    override var prefersStatusBarHidden: Bool { true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .slide }
}
#endif
