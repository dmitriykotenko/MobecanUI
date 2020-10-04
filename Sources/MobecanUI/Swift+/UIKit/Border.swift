//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct Border: Equatable, Hashable, Lensable {
  
  public var color: UIColor
  public var width: CGFloat
  
  public static var none = Border(color: .clear, width: 0)
  public static var debug = Border(color: .red, width: 1)
  
  public init(color: UIColor,
              width: CGFloat) {
    self.color = color
    self.width = width
  }
}
