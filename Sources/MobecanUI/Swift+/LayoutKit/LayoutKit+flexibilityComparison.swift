// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


public extension LayoutArrangement {

  @inlinable
  func isMoreFlexible(than that: LayoutArrangement,
                      axis: Axis) -> Bool {
    layout.isMoreFlexible(than: that.layout, axis: axis)
  }

  @inlinable
  func isLessFlexible(than that: LayoutArrangement,
                      axis: Axis) -> Bool {
    that.isMoreFlexible(than: self, axis: axis)
  }
}


public extension LayoutMeasurement {

  @inlinable
  func isMoreFlexible(than that: LayoutMeasurement,
                      axis: Axis) -> Bool {
    layout.isMoreFlexible(than: that.layout, axis: axis)
  }

  @inlinable
  func isLessFlexible(than that: LayoutMeasurement,
                      axis: Axis) -> Bool {
    that.isMoreFlexible(than: self, axis: axis)
  }
}


public extension Layout {

  @inlinable
  func isMoreFlexible(than that: Layout,
                      axis: Axis) -> Bool {
    flexibility.isGreater(than: that.flexibility, axis: axis)
  }

  @inlinable
  func isLessFlexible(than that: Layout,
                      axis: Axis) -> Bool {
    that.isMoreFlexible(than: self, axis: axis)
  }
}


public extension Flexibility {

  func isGreater(than that: Flexibility,
                 axis: Axis) -> Bool {
    flex(axis).isGreater(than: that.flex(axis))
  }

  func isLess(than that: Flexibility,
              axis: Axis) -> Bool {
    that.isGreater(than: self, axis: axis)
  }
}


private extension Flexibility.Flex {

  func isGreater(than that: Flexibility.Flex) -> Bool {
    zip(self, that).map { $0 > $1 }
    ?? (self != nil && that == nil)
  }

  func isLess(than that: Flexibility.Flex) -> Bool {
    that.isGreater(than: self)
  }
}
