// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension CGPoint {

  static func + (point: CGPoint, size: CGSize) -> CGPoint {
    .init(
      x: point.x + size.width,
      y: point.y + size.height
    )
  }
}
