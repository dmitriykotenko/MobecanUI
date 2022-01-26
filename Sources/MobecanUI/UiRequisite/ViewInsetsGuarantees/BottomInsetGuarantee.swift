// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public protocol BottomInsetGuarantee {
  
  func guaranteedBottomInset(for view: UIView) -> CGFloat?
}
