//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIEdgeInsets {
  
  var negated: UIEdgeInsets {
    UIEdgeInsets(
      top: -top,
      left: -left,
      bottom: -bottom,
      right: -right
    )
  }
}
