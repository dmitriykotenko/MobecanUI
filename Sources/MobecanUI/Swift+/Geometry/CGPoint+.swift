// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGPoint {

  static func + (this: CGPoint, that: CGPoint) -> CGPoint {
    CGPoint(
      x: this.x + that.x,
      y: this.y + that.y
    )
  }

  static func - (this: CGPoint, that: CGPoint) -> CGPoint {
    CGPoint(
      x: this.x - that.x,
      y: this.y - that.y
    )
  }

  static func + (point: CGPoint, size: CGSize) -> CGPoint {
    .init(
      x: point.x + size.width,
      y: point.y + size.height
    )
  }

  func distance(to that: CGPoint) -> CGFloat {
    sqrt(
      (x - that.x) * (x - that.x) + (y - that.y) * (y - that.y)
    )
  }
}
