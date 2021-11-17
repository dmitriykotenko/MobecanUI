//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension UIView {
  
  static func circle(radius: CGFloat) -> UIView {
    LayoutableView(
      layout: SizeLayout<LayoutableView>(width: 2 * radius, height: 2 * radius)
    )
    .cornerRadius(radius)
    .clipsToBounds(true)
  }
}
