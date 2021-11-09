// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIResponder {

  var parentViewController: UIViewController? {
    (next as? UIViewController) ?? next?.parentViewController
  }
}
