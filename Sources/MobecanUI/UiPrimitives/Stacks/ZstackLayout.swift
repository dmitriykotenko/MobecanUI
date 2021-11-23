//  Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class ZstackLayout: BaseLayout<UIView>, Layout {

  private let sublayouts: [Layout]

  init(sublayouts: [Layout],
       flexibility: Flexibility? = nil) {
    self.sublayouts = sublayouts

    super.init(
      alignment: .fill,
      flexibility: flexibility ?? .init(
        horizontal: sublayouts.minimumFlexibility(.horizontal) ?? Flexibility.inflexibleFlex,
        vertical: sublayouts.minimumFlexibility(.vertical) ?? Flexibility.inflexibleFlex
      ),
      config: nil
    )
  }

  override open func configure(view: UIView) {}
  open func configure(baseTypeView: UIView) {}

  open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    let childMeasurements =
      sublayouts.map { $0.measurement(within: maxSize) }

    return LayoutMeasurement(
      layout: self,
      size: childMeasurements.sizeThatFits(maxSize),
      maxSize: maxSize,
      sublayouts: childMeasurements
    )
  }

  open func arrangement(within frame: CGRect,
                        measurement: LayoutMeasurement) -> LayoutArrangement {
    let bounds = CGRect(origin: .zero, size: measurement.size)

    return LayoutArrangement(
      layout: self,
      frame: .init(origin: frame.origin, size: measurement.size),
      sublayouts: measurement.sublayouts.map { $0.arrangement(within: bounds) }
    )
  }
}


private extension Array where Element == Layout {

  func minimumFlexibility(_ axis: Axis) -> Flexibility.Flex? {
    let leastFlexibleLayout = self.min { $0.isLessFlexible(than: $1, axis: axis) }
    return leastFlexibleLayout?.flexibility.flex(axis)
  }
}


private extension Array where Element == LayoutMeasurement {

  func sizeThatFits(_ maxSize: CGSize) -> CGSize {
    let horizontallyLeastFlexible =
      self.min { $0.isMoreFlexible(than: $1, axis: .horizontal) }

    let verticallyLeastFlexible =
      self.min { $0.isMoreFlexible(than: $1, axis: .vertical) }

    return CGSize(
      width: horizontallyLeastFlexible?.size.width ?? maxSize.width,
      height: verticallyLeastFlexible?.size.height ?? maxSize.height
    )
  }
}
