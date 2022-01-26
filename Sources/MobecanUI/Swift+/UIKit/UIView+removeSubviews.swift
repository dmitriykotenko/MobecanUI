// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SnapKit
import UIKit


public extension UIView {

  func removeAllSubviews() {
    subviews.forEach { $0.removeFromSuperview() }
  }
}
