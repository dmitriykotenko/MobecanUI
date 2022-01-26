// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UIButton {

  var isPseudoDisabled: Binder<Bool> {
    Binder(base) { button, isPseudoDisabled in
      button.isPseudoDisabled = isPseudoDisabled
    }
  }

  func tapWhen(isPseudoDisabled: Bool) -> ControlEvent<Void> {
    tapWhen {
      $0.isPseudoDisabled == isPseudoDisabled
    }
  }

  func tapWhen(_ state: UIControl.State) -> ControlEvent<Void> {
    tapWhen { $0.state == state }
  }

  func tapWhenNot(_ state: UIControl.State) -> ControlEvent<Void> {
    tapWhen { $0.state != state }
  }

  func tapWhen(_ condition: @escaping (Base) -> Bool) -> ControlEvent<Void> {
    ControlEvent(
      events: tap.filter { [weak base] in
        base.map(condition) == true
      }
    )
  }
}
