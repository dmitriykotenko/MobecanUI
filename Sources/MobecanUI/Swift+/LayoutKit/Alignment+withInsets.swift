//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension Alignment {

  static func top(inset: CGFloat) -> Alignment {
    .init { size, frame in
      CGRect.from(
        y: frame.minY + inset,
        size: size,
        centerHorizontallyIn: frame
      )
    }
  }

  static func centerVertically(offset: CGFloat) -> Alignment {
    .init { size, frame in
      CGRect.from(
        y: frame.midY - (size.height / 2.0) + offset,
        size: size,
        centerHorizontallyIn: frame
      )
    }
  }

  static func bottom(inset: CGFloat) -> Alignment {
    .init { size, frame in
      CGRect.from(
        y: frame.maxY - size.height - inset,
        size: size,
        centerHorizontallyIn: frame
      )
    }
  }

  static func centerOrTop(thresholdHeight: CGFloat) -> Alignment {
    .init { size, frame in
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
