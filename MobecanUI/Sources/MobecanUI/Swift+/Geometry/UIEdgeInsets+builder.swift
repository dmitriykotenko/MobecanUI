//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIEdgeInsets {
  
  init(amount: CGFloat) {
    self.init(
      top: amount,
      left: amount,
      bottom: amount,
      right: amount
    )
  }
  
  init(horizontal: CGFloat, vertical: CGFloat) {
    self.init(
      top: vertical,
      left: horizontal,
      bottom: vertical,
      right: horizontal
    )
  }
  
  static func vertical(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: amount, bottom: amount)
  }
  
  static func horizontal(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(left: amount, right: amount)
  }
  
  static func top(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: amount)
  }
  
  static func bottom(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(bottom: amount)
  }
  
  static func left(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(left: amount)
  }
  
  static func right(_ amount: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(right: amount)
  }
  
  init(top: CGFloat? = nil,
       left: CGFloat? = nil,
       bottom: CGFloat? = nil,
       right: CGFloat? = nil) {
    self.init(
      top: top ?? 0,
      left: left ?? 0,
      bottom: bottom ?? 0,
      right: right ?? 0
    )
  }

  func with(top: CGFloat? = nil,
            left: CGFloat? = nil,
            bottom: CGFloat? = nil,
            right: CGFloat? = nil,
            vertical: CGFloat? = nil,
            horizontal: CGFloat? = nil) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: vertical ?? top ?? self.top,
      left: horizontal ?? left ?? self.left,
      bottom: vertical ?? bottom ?? self.bottom,
      right: horizontal ?? right ?? self.right
    )
  }
  
  static func + (this: UIEdgeInsets,
                 that: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: this.top + that.top,
      left: this.left + that.left,
      bottom: this.bottom + that.bottom,
      right: this.right + that.right
    )
  }
}
