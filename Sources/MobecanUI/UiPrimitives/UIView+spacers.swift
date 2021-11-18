//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import SnapKit
import UIKit


public extension UIView {
  
  static func zeroHeightView(layoutPriority: ConstraintPriority = .required) -> LayoutableView {
    LayoutableView(
      layout: SizeLayout(height: 0)
    )
  }

  static func spacer(width: CGFloat? = nil,
                     height: CGFloat? = nil,
                     layoutPriority: ConstraintPriority = .required) -> LayoutableView {
    LayoutableView(
      layout: SizeLayout(
        minWidth: width,
        maxWidth: width,
        minHeight: height,
        maxHeight: height
      )
    )
  }

  static func stretchableSpacer(minimumWidth: CGFloat? = nil,
                                minimumHeight: CGFloat? = nil) -> LayoutableView {
    LayoutableView(
      layout: SizeLayout(
        minWidth: minimumWidth,
        minHeight: minimumHeight
      )
    )
  }

  static func rxHorizontalSpacer(_ targetView: UIView,
                                 insets: UIEdgeInsets = .zero) -> UIView {
    ReactiveSpacerView(
      targetView: targetView,
      axis: [.horizontal],
      insets: insets
    )
  }
  
  static func rxVerticalSpacer(_ targetView: UIView,
                               insets: UIEdgeInsets = .zero) -> UIView {
    ReactiveSpacerView(
      targetView: targetView,
      axis: [.vertical],
      insets: insets
    )
  }
  
  static func rxSpacer(_ targetView: UIView,
                       insets: UIEdgeInsets = .zero) -> UIView {
    ReactiveSpacerView(
      targetView: targetView,
      axis: [.horizontal, .vertical],
      insets: insets
    )
  }
}
