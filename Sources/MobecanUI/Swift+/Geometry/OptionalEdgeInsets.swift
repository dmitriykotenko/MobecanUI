//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct OptionalEdgeInsets {
  
  public let top: CGFloat?
  public let left: CGFloat?
  public let bottom: CGFloat?
  public let right: CGFloat?
  
  public static let empty = OptionalEdgeInsets(
    top: nil,
    left: nil,
    bottom: nil,
    right: nil
  )

  public init(top: CGFloat? = nil,
              left: CGFloat? = nil,
              bottom: CGFloat? = nil,
              right: CGFloat? = nil) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }

  public static func top(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(top: inset)
  }

  public static func bottom(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(bottom: inset)
  }

  public static func left(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(left: inset)
  }

  public static func right(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(right: inset)
  }

  public static func vertical(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(top: inset, bottom: inset)
  }

  public static func horizontal(_ inset: CGFloat) -> OptionalEdgeInsets {
    .init(left: inset, right: inset)
  }
}


public extension UIEdgeInsets {
  
  func withOptional(_ optionalInsets: OptionalEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(
      top: optionalInsets.top ?? top,
      left: optionalInsets.left ?? left,
      bottom: optionalInsets.bottom ?? bottom,
      right: optionalInsets.right ?? right
    )
  }
}
