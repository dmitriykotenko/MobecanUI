//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public extension UIControl {

  func enabled(_ enabled: Bool = true) -> Self {
    self.isEnabled = enabled
    return self
  }
  
  func disabled() -> Self {
    return enabled(false)
  }
  
  func selected(_ selected: Bool) -> Self {
    self.isSelected = selected
    return self
  }
}
