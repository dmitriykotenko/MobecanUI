// Copyright © 2021 Mobecan. All rights reserved.

import CoreGraphics
import LayoutKit
import UIKit


public extension AlignedLayout {

  static func top(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .topFill,
      sublayouts: [subview.asLayout]
    )
  }

  static func bottom(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .bottomFill,
      sublayouts: [subview.asLayout]
    )
  }

  static func leading(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .fillLeading,
      sublayouts: [subview.asLayout]
    )
  }

  static func trailing(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .fillTrailing,
      sublayouts: [subview.asLayout]
    )
  }

  static func horizontallyCentered(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .init(
        vertical: .fill,
        horizontal: .center
      ),
      sublayouts: [subview.asLayout]
    )
  }

  static func verticallyCentered(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .init(
        vertical: .center,
        horizontal: .fill
      ),
      sublayouts: [subview.asLayout]
    )
  }

  static func centered(_ subview: UIView) -> AlignedLayout {
    .init(
      childAlignment: .center,
      sublayouts: [subview.asLayout]
    )
  }
}
