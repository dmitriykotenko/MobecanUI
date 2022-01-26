// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class EmptyLayout: Layout {

  public init() {}

  open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    .init(
      layout: self,
      size: maxSize,
      maxSize: maxSize,
      sublayouts: []
    )
  }

  open func arrangement(within rect: CGRect,
                        measurement: LayoutMeasurement) -> LayoutArrangement {
    LayoutArrangement(
      layout: self,
      frame: rect,
      sublayouts: []
    )
  }

  open var needsView: Bool { false }

  open func makeView() -> UIView { UIView() }

  open func configure(baseTypeView: UIView) {}

  open var flexibility: Flexibility { .flexible }

  open var viewReuseId: String? { nil }
}
