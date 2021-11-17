//  Copyright © 2020 Mobecan. All rights reserved.

import SnapKit
import UIKit


public extension UIView {

  static func centeredHorizontally(_ subview: UIView,
                                   offset: CGFloat = 0,
                                   priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideOverlay(
      alignment: .init(
        vertical: .fill,
        horizontal: .center
      ),
      insets: .init(
        left: offset,
        right: -offset
      )
    )
  }

  static func centeredVertically(_ subview: UIView,
                                 offset: CGFloat = 0,
                                 priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideOverlay(
      alignment: .init(
        vertical: .center,
        horizontal: .fill
      ),
      insets: .init(
        top: offset,
        bottom: -offset
      )
    )
  }

  static func centered(_ subview: UIView,
                       offset: CGSize = .zero,
                       priority: ConstraintPriority = .required) -> LayoutableView {
    subview.insideOverlay(
      alignment: .center,
      insets: .init(
        top: offset.height,
        left: offset.width,
        bottom: -offset.height,
        right: -offset.width
      )
    )
  }
}
