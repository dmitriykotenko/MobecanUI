// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension ObservableType {

  static func ==> (signal: Self, handler: @escaping (Element) -> Void) -> Disposable {
    signal.subscribe(onNext: handler)
  }
}


public extension ObservableConvertibleType {

  static func ==> (signal: Self, handler: @escaping (Element) -> Void) -> Disposable {
    signal.asObservable().subscribe(onNext: handler)
  }
}


public extension ObservableType where Element == Void {

  static func ==> (signal: Self, handler: @autoclosure @escaping () -> Void) -> Disposable {
    signal.subscribe(onNext: handler)
  }
}


public extension ObservableConvertibleType where Element == Void {

  static func ==> (signal: Self, handler: @autoclosure @escaping () -> Void) -> Disposable {
    signal.asObservable().subscribe(onNext: handler)
  }
}
