// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGSize {

  func insetBy(_ insets: UIEdgeInsets) -> CGSize {
    CGSize(
      width: width - insets.left - insets.right,
      height: height - insets.top - insets.bottom
    )
  }

  func boundedByWidth(_ width: CGFloat) -> CGSize {
    self[\.width, min(self.width, width)]
  }

  func boundedByHeight(_ height: CGFloat) -> CGSize {
    self[\.height, min(self.height, height)]
  }

  func bounded(by that: CGSize) -> CGSize {
    .init(
      width: min(width, that.width),
      height: min(height, that.height)
    )
  }

  static let greatestFinite = CGSize(
    width: CGFloat.greatestFiniteMagnitude,
    height: CGFloat.greatestFiniteMagnitude
  )

  static func square(size: CGFloat) -> CGSize {
    .init(width: size, height: size)
  }

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
