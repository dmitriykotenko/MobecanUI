// Copyright © 2021 Mobecan. All rights reserved.

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
                       preferredHeightPriority: ConstraintPriority = .required) -> Self {
    self
      .minimumHeight(heightRange.lowerBound)
      .maximumHeight(heightRange.upperBound)
      .height(preferredHeight.asCGFloat, priority: preferredHeightPriority)
  }
}
