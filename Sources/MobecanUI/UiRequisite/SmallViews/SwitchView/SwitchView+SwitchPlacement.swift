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
      return Alignment { size, frame in
        CGRect.from(
          y: frame.minY + inset,
          size: size,
          centerHorizontallyIn: frame
        )
      }
    case .center(let offset):
      return Alignment { size, frame in
        CGRect.from(
          y: frame.midY - (size.height / 2.0) + offset,
          size: size,
          centerHorizontallyIn: frame
        )
      }
    case .bottom(let inset):
      return Alignment { size, frame in
        CGRect.from(
          y: frame.maxY - size.height - inset,
          size: size,
          centerHorizontallyIn: frame
        )
      }
    case .centerOrTop(let thresholdHeight):
      return Alignment { size, frame in
        let y = (frame.height < thresholdHeight) ?
        frame.midY - (size.height / 2.0) :
        frame.minY + (thresholdHeight / 2.0) - (size.height / 2.0)

        return CGRect.from(
          y: y,
          size: size,
          centerHorizontallyIn: frame
        )
      }
    }
  }
}


private extension CGRect {

  static func from(y: CGFloat,
                   size: CGSize,
                   centerHorizontallyIn frame: CGRect) -> CGRect {
    let (x, width) = Alignment.Horizontal.center.align(
      length: size.width,
      availableLength: frame.width,
      offset: frame.origin.x
    )

    return CGRect(x: x, y: y, width: width, height: size.height)
  }
}
