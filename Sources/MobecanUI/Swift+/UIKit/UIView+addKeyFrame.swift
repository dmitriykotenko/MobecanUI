//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIView {

  func addKeyframe<Value>(start: Double,
                          duration: Double,
                          property: WritableKeyPath<UIView, Value>,
                          value: Value) {
    UIView.addKeyframe(
      withRelativeStartTime: start,
      relativeDuration: duration,
      animations: { [weak self] in self?[keyPath: property] = value }
    )
  }
}
