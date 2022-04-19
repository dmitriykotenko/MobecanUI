// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIAlertController {

  /// On iPad, we must specify pin rectangle for action sheet UIAlertControllers —
  /// otherwise, the application crashes when presenting the alert:
  /// https://stackoverflow.com/questions/31577140/uialertcontroller-is-crashed-ipad
  ///
  /// On iPhone, pinning has no effect.
  func pin(to view: UIView?) {
    view.map {
      popoverPresentationController?.sourceView = $0
      popoverPresentationController?.sourceRect = $0.frame[\.origin, .zero]
    }
  }

  /// On iPad, we must specify pin rectangle for action sheet UIAlertControllers —
  /// otherwise, the application crashes when presenting the alert:
  /// https://stackoverflow.com/questions/31577140/uialertcontroller-is-crashed-ipad
  ///
  /// On iPhone, pinning has no effect.
  @discardableResult
  func pinned(to view: UIView?) -> Self {
    pin(to: view)
    return self
  }
}
