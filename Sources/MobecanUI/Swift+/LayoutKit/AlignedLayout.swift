//  Copyright © 2021 Mobecan. All rights reserved.

import CoreGraphics
import LayoutKit
import UIKit


open class AlignedLayout: BaseLayout<UIView>, ConfigurableLayout {

  public let sublayouts: [Layout]
  public let childAlignment: Alignment

  public init(alignment: Alignment = .fill,
              childAlignment: Alignment = .fill,
              flexibility: Flexibility = .flexible,
              sublayouts: [Layout]) {
    self.childAlignment = childAlignment
    self.sublayouts = sublayouts

    super.init(
      alignment: alignment,
      flexibility: flexibility,
      viewReuseId: nil,
      config: nil
    )
  }

  open func measurement(within maxSize: CGSize) -> LayoutMeasurement {
    let children = sublayouts.map { $0.measurement(within: maxSize) }

    let maxChildSize = CGSize(
      width: children.map(\.size.width).max() ?? 0,
      height: children.map(\.size.height).max() ?? 0
    )

    return LayoutMeasurement(
      layout: self,
      size:  childAlignment.increase(maxChildSize, to: maxSize),
      maxSize: maxSize,
      sublayouts: children
    )
  }

  open func arrangement(within rect: CGRect,
                        measurement: LayoutMeasurement) -> LayoutArrangement {
    let frame = CGRect(origin: rect.origin, size: measurement.size)
    let bounds = CGRect(origin: .zero, size: measurement.size)

    return LayoutArrangement(
      layout: self,
      frame: frame,
      sublayouts: measurement.sublayouts.map {
        $0.arrangement(within: childAlignment.position(size: $0.size, in: bounds))
      }
    )
  }
}


private extension Alignment {

  func increase(_ smallerSize: CGSize,
                to largerSize: CGSize) -> CGSize {
    let maximumWidth = max(smallerSize.width, largerSize.width)
    let maximumHeight = max(smallerSize.height, largerSize.height)

    return CGSize(
      width: shouldFillWidth ? smallerSize.width : maximumWidth,
      height: shouldFillHeight ? smallerSize.height : maximumHeight
    )
  }

  var shouldFillWidth: Bool {
    position(size: .zero, in: .veryLargeRect).width > 0
  }

  var shouldFillHeight: Bool {
    position(size: .zero, in: .veryLargeRect).height > 0
  }
}


private extension CGRect {

  static let veryLargeRect = CGRect(
    x: 0,
    y: 0,
    width: CGFloat.greatestFiniteMagnitude,
    height: CGFloat.greatestFiniteMagnitude
  )
}
