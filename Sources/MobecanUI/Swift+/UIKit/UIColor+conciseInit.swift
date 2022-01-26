// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension UIColor {

  convenience init(r: Int, g: Int, b: Int, alpha: CGFloat) {
    self.init(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: alpha
    )
  }
}
