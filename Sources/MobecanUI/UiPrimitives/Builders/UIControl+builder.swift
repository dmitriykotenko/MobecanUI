// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIControl {

  @discardableResult
  func enabled(_ enabled: Bool = true) -> Self {
    self.isEnabled = enabled
    return self
  }
  
  @discardableResult
  func disabled() -> Self {
    enabled(false)
  }
  
  @discardableResult
  func selected(_ selected: Bool) -> Self {
    self.isSelected = selected
    return self
  }
}
