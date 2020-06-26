//  Copyright © 2019 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIButton {

  func foreground(for state: UIControl.State = .normal) -> Binder<ButtonForeground> {
    return Binder(base) { button, foreground in
      button.setForeground(foreground, for: state)
    }
  }
}
