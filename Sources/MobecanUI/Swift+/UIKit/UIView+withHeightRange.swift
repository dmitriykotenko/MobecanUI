// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import SnapKit
import UIKit


public extension UIView {

  enum HeightGuide {
    case minimum, maximum

    var asCGFloat: CGFloat {
      switch self {
      case .minimum:
        return 0
      case .maximum:
        return CGFloat.greatestFiniteMagnitude
      }
    }
  }

  func withHeightRange(_ heightRange: ClosedRange<CGFloat>,
                       preferredHeight: HeightGuide,
                       preferredHeightPriority: ConstraintPriority = .required) -> LayoutableView {
    LayoutableView(
      layout: SizeLayout<UIView>(
        minHeight: heightRange.lowerBound,
        maxHeight: heightRange.upperBound,
        sublayout: SizeLayout<UIView>(
          height: preferredHeight.asCGFloat,
          flexibility: .init(
            horizontal: Flexibility.inflexibleFlex,
            vertical: -Int32(preferredHeightPriority.value)
          ),
          sublayout: .fromView(self)
        )
      )
    )
  }
}
