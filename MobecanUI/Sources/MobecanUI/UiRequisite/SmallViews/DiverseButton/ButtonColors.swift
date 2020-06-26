//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct ButtonColors {
  
  public let title: UIColor?
  public let tint: UIColor?
  public let background: UIColor?
  public let shadow: UIColor?
  
  public init(title: UIColor? = nil,
              tint: UIColor? = nil,
              background: UIColor? = nil,
              shadow: UIColor? = nil) {
    self.title = title
    self.tint = tint
    self.background = background
    self.shadow = shadow
  }
}
