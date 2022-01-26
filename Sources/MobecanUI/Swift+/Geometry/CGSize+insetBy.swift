// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGSize {
  
  func insetBy(_ insets: UIEdgeInsets) -> CGSize {
    CGSize(
      width: width - insets.left - insets.right,
      height: height - insets.top - insets.bottom
    )
  }
}
