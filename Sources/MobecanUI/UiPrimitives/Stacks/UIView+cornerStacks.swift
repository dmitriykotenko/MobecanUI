// Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  static func topLeading(_ subview: UIView,
                         topInset: CGFloat = 0,
                         leadingInset: CGFloat = 0,
                         priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .topLeading,
      insets: .init(top: topInset, left: leadingInset)
    )
  }

  static func topTrailing(_ subview: UIView,
                          topInset: CGFloat = 0,
                          trailingInset: CGFloat = 0,
                          priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .topTrailing,
      insets: .init(top: topInset, right: trailingInset)
    )
  }

  static func bottomLeading(_ subview: UIView,
                            bottomInset: CGFloat = 0,
                            leadingInset: CGFloat = 0,
                            priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .bottomLeading,
      insets: .init(left: leadingInset, bottom: bottomInset)
    )
  }

  static func bottomTrailing(_ subview: UIView,
                             bottomInset: CGFloat = 0,
                             trailingInset: CGFloat = 0,
                             priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideAlignedLayout(
      alignment: .bottomTrailing,
      insets: .init(bottom: bottomInset, right: trailingInset)
    )
  }
}
