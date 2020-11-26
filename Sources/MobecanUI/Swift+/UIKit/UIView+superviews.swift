//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {

  func superviews(upTo finalSuperview: UIView) -> [UIView] {
    Array(
      andSuperviews(upTo: finalSuperview).dropFirst()
    )
  }

  func andSuperviews(upTo finalSuperview: UIView) -> [UIView] {
    if finalSuperview == self {
      return [self]
    } else {
      let ancestors = superview.map { $0.andSuperviews(upTo: finalSuperview) }
      
      return [self] + (ancestors ?? [])
    }
  }

  func nearestSuperview(where condition: @escaping (UIView) -> Bool) -> UIView? {
    switch superview {
    case nil:
      return nil
    case let view? where condition(view):
      return view
    default:
      return superview?.nearestSuperview(where: condition)
    }
  }
}
