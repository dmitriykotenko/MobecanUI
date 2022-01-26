// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public protocol HeightAwareView: UIView {
  
  associatedtype Value
  
  func heightFor(value: Value, width: CGFloat) -> CGFloat
}
