// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class SafeAreaLayout: BaseLayout<UIView>, Layout {

  private let owningView: UIView
  private let sublayout: Layout

  init(owningView: UIView,
       flexibility: Flexibility? = nil,
       sublayout: Layout) {
    self.owningView = owningView
    self.sublayout = sublayout

    super.init(
      alignment: .fill,
      flexibility: flexibility ?? sublayout.flexibility,
      config: nil
    )
  }

  override open func configure(view: UIView) {}
  open func configure(baseTypeView: UIView) {}

  open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    let safeAreaInsets = owningView.safeAreaInsets
    let maxSafeAreaSize = maxSize.insetBy(safeAreaInsets)

    let childMeasurement = sublayout.measurement(within: maxSafeAreaSize)

    return LayoutMeasurement(
      layout: self,
      size: childMeasurement.size.insetBy(safeAreaInsets.negated),
      maxSize: maxSize,
      sublayouts: [childMeasurement]
    )
  }

  open func arrangement(within frame: CGRect,
                        measurement: LayoutMeasurement) -> LayoutArrangement {
    let safeAreaInsets = owningView.safeAreaInsets

    let bounds = CGRect(origin: .zero, size: measurement.size)
    let safeAreaBounds = bounds.inset(by: safeAreaInsets)

    return LayoutArrangement(
      layout: self,
      frame: .init(
        origin: frame.origin,
        size: measurement.size
      ),
      sublayouts: measurement.sublayouts.map { $0.arrangement(within: safeAreaBounds) }
    )
  }
}
