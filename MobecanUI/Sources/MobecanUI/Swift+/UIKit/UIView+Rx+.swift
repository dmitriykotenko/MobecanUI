//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIView {
  
  var borderColor: Binder<UIColor?> {
    return Binder(base) { view, borderColor in
      view.layer.borderColor = borderColor?.cgColor
    }
  }

  var shadowColor: Binder<UIColor?> {
    return Binder(base) { view, shadowColor in
      view.layer.shadowColor = shadowColor?.cgColor
    }
  }
  
  var isUserInteractionDisabled: Binder<Bool> {
    return Binder(base) { view, disabled in
      view.isUserInteractionEnabled = !disabled
    }
  }
  
  var isVisible: Binder<Bool> {
    return Binder(base) { view, isVisible in
      view.isHidden = !isVisible
    }
  }
  
  var transform: Binder<CGAffineTransform> {
    return Binder(base) { view, transform in
      view.transform = transform
    }
  }
}
