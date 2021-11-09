// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIViewController {

  func putChild(_ child: UIViewController,
                inside containerView: UIView? = nil,
                childViewPosition: SubviewPosition? = nil) {
    addChild(child)
    (containerView ?? view).putSubview(child.view, childViewPosition)
    child.didMove(toParent: self)
  }

  func removeFromParentViewController() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    didMove(toParent: nil)
  }
}
