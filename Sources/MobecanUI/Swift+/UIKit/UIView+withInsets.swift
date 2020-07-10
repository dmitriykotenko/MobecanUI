//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {
  
  func withInsets(_ insets: UIEdgeInsets) -> UIView {
    AutohidingContainerView(self, insets: insets)
  }
}
