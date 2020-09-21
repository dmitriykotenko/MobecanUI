//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {

  /// Disables constraints which are automatically created by auto-layout during view initialization.
  ///
  /// Usually these constraints conflict with ones created by the user.
  func disableTemporaryConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    setNeedsLayout()
    layoutIfNeeded()
  }
}
