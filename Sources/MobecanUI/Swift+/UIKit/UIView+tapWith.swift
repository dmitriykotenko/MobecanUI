// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UIView {

  func tapWith<Value, ValueSignal: ObservableType>(value: ValueSignal) -> Observable<Value>
  where ValueSignal.Element == Value? {
    rx.tapGesture()
      .when(.recognized)
      .withLatestFrom(value.filterNil())
  }
}
