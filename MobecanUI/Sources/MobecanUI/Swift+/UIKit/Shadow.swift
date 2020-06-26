//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public struct Shadow: Lensable {
  
  public var color: UIColor
  public var opacity: Float
  public var radius: CGFloat
  public var offset: CGSize
  
  public static var empty = Shadow(color: .clear, opacity: 0, radius: 0, offset: .zero)
  
  public static var debug = Shadow(color: .red, opacity: 1, radius: 10, offset: .zero)
  
  public init(color: UIColor,
              opacity: Float,
              radius: CGFloat,
              offset: CGSize) {
    self.color = color
    self.opacity = opacity
    self.radius = radius
    self.offset = offset
  }
}
