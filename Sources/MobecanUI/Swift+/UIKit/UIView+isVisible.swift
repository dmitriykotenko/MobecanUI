// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIView {
  
  var isVisible: Bool {
    get { !isHidden }
    set { isHidden = !newValue }
  }
}
