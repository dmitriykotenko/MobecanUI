// Copyright © 2022 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension LayoutableView {

  static func fromSingleSubview(_ subview: UIView,
                                alignment: Alignment = .fill,
                                insets: UIEdgeInsets = .zero) -> LayoutableView {
    .init(
      layout: InsetLayout<UIView>.fromSingleSubview(
        subview,
        alignment: alignment,
        insets: insets
      )
    )
  }
}
