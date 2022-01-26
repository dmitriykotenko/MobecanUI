// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UITextField {
  
  var editingDidBegin: Signal<Void> {
    base.rx.isFirstResponder
      .filter { $0 == true }
      .mapToVoid()
      .asSignal(onErrorJustReturn: ())
  }
  
  var editingDidEnd: Signal<Void> {
    base.rx.isFirstResponder
      .filter { $0 == false }
      .mapToVoid()
      .asSignal(onErrorJustReturn: ())
  }
}
