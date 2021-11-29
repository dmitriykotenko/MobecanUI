//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension SwitchView {

  /// Vertical placement of UISwitch.
  enum SwitchPlacement {

    /// Place UISwitch at the top with given inset.
    case top(inset: CGFloat)

    /// Place UISwitch at the bottom with given inset.
    case bottom(inset: CGFloat)

    /// Place UISwitch at the vertical center with given offset.
    case center(offset: CGFloat)

    /// Vertically center UISwitch until given maximum height.
    ///
    /// If SwitchView height is less than or equal to maximumCenteredHeight, vertically center UISwitch.
    ///
    /// If SwitchView height is greater than maximumCenteredHeight,
    /// set UISwitch's vertical center at 0.5 * maximumCenteredHeight.
    case centerOrTop(maximumCenteredHeight: CGFloat)
  }
}


extension SwitchView.SwitchPlacement {

  var asAlignment: LayoutKit.Alignment {
    switch self {
    case .top(let inset):
      return .top(inset: inset)
    case .center(let offset):
      return .centerVertically(offset: offset)
    case .bottom(let inset):
      return .bottom(inset: inset)
    case .centerOrTop(let thresholdHeight):
      return .centerOrTop(thresholdHeight: thresholdHeight)
    }
  }
}
