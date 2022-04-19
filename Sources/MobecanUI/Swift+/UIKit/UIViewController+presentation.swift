// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIViewController {

  /// Whether the view controller is presenting another view controller.
  var isPresentingAnotherViewController: Bool {
    // Sometimes presentedViewController != nil,
    // but it is presented by another view controller, not by self.
    // That's why (presentedViewController != nil) check is not sufficient.
    presentedViewController?.presentingViewController == self
  }

  func enableFullScreenPresentation() {
    modalPresentationStyle = .overFullScreen
    modalTransitionStyle = .coverVertical
  }

  /// When presenting the view controller on iPad, place at the center of presenting view controller.
  @discardableResult
  func presentedAtTheCenter(of sourceView: UIView) -> Self {
    // Hide Popover's arrow on iPad.
    popoverPresentationController?.permittedArrowDirections = []

    // When running on iPad, present self at the center of presenting view controller.
    popoverPresentationController?.sourceView = sourceView
    popoverPresentationController?.sourceRect = CGRect(origin: sourceView.center, size: .zero)

    return self
  }
}
