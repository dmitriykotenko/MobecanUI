// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension ObservableType {

  func wait<Signal: ObservableConvertibleType>(for signal: Signal) -> Observable<Element>
  where Signal.Element == Bool {
    Observable
      .combineLatest(self, signal.asObservable())
      .compactMap { $1 ? $0 : nil }
  }
}
