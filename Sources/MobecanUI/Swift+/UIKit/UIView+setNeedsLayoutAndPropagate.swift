//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


public extension UIView {

  /// Calls `setNeedsLayout()` method and then notifies the superview about layout invalidation.
  ///
  /// The superview can handle invalidation message by implementing `LayoutInvalidationPropagator` protocol.
  func setNeedsLayoutAndPropagate() {
    setNeedsLayout()
    superview?.subviewNeedsToLayout(subview: self)
  }
}
