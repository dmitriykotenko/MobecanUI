// Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import SnapKit
import UIKit


public extension UIView {

  static func top(_ subview: UIView,
                  inset: CGFloat = 0,
                  priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .topFill,
      insets: .top(inset)
    )
  }
  
  static func bottom(_ subview: UIView,
                     inset: CGFloat = 0,
                     priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .bottomFill,
      insets: .bottom(inset)
    )
  }
  
  static func leading(_ subview: UIView,
                      inset: CGFloat = 0,
                      priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .fillLeading,
      insets: .left(inset)
    )
  }
  
  static func trailing(_ subview: UIView,
                       inset: CGFloat = 0,
                       priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .fillTrailing,
      insets: .right(inset)
    )
  }
}
