//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGPoint {

  static func - (this: CGPoint, that: CGPoint) -> CGPoint {
    return CGPoint(
      x: this.x - that.x,
      y: this.y - that.y
    )
  }
}
