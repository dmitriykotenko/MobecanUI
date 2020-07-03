//  Copyright © 2020 Mobecan. All rights reserved.


import UIKit


public extension UIView {
  
  static func circle(radius: CGFloat) -> UIView {
    UIView()
      .width(2 * radius).height(2 * radius)
      .cornerRadius(radius)
      .clipsToBounds(true)
  }
}
