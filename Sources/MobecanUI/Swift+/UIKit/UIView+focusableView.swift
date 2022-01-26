// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  var canBeFocused: Bool {
    focusableView.canBecomeFirstResponder
  }
  
  var focusableView: UIView {
    if canBecomeFirstResponder {
      return self
    } else {
      return subviews.lazy
        .compactMap { $0.focusableView }
        .first
        ?? self
    }
  }
}
