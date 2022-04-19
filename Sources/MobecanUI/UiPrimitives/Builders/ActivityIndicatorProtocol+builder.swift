// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension ActivityIndicatorProtocol {
  
  @discardableResult
  func color(_ color: UIColor?) -> Self {
    self.color = color
    return self
  }
}
