// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxGesture
import RxSwift
import UIKit


public extension UILongPressGestureRecognizer {

  /// Находятся ли текущие координаты жеста внутри родительской вьюшки.
  var isHappeningInsideView: Bool {
    isHappening(inside: view)
  }

  /// Находятся ли текущие координаты жеста внутри указанной вьюшки.
  func isHappening(inside view: UIView?) -> Bool {
    let absoluteFrameOfView = view.flatMap { $0.window?.convert($0.frame, from: $0.superview) }
    let touchLocation = location(in: view?.window)

    return absoluteFrameOfView?.contains(touchLocation) ?? false
  }
}
