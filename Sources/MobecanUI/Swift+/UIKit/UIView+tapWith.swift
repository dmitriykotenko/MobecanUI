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


public extension Reactive where Base: UIView {

  func tapWith<Value, ValueSignal: ObservableType>(value: ValueSignal,
                                                   filter: @escaping (Base) -> Bool) -> Observable<Value>
  where ValueSignal.Element == Value? {
    tapGesture()
      .when(.recognized)
      .filter { [weak base] _ in base.map(filter) ?? false }
      .withLatestFrom(value.filterNil())
  }
}
