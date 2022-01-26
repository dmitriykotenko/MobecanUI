// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public extension CGSize {

  static func + (this: CGSize, that: CGSize) -> CGSize {
    .init(
      width: this.width + that.width,
      height: this.height + that.height
    )
  }

  static func - (this: CGSize, that: CGSize) -> CGSize {
    .init(
      width: this.width - that.width,
      height: this.height - that.height
    )
  }
}
