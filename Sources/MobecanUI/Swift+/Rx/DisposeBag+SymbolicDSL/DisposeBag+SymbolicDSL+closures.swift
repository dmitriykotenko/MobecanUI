// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension Observable {

  static func ==> (signal: Observable<Element>,
                   handler: @escaping (Element) -> Void) -> MobecanDisposable {
    .init(signal: signal, handler: handler)
  }
}


public extension ObservableConvertibleType {

  static func ==> (signal: Self,
                   handler: @escaping (Element) -> Void) -> MobecanDisposable {
    .init(signal: signal, handler: handler)
  }
}


public extension Observable<Void> {

  static func ==> (signal: Observable<Void>,
                   handler: @autoclosure @escaping () -> Void) -> MobecanDisposable {
    .init(signal: signal, handler: handler)
  }
}


public extension ObservableConvertibleType where Element == Void {

  static func ==> (signal: Self,
                   handler: @autoclosure @escaping () -> Void) -> MobecanDisposable {
    .init(signal: signal, handler: handler)
  }
}


public extension Optional {

  static func ?==> <Element>(signal: Observable<Element>?,
                             handler: @escaping (Element) -> Void) -> MobecanDisposable
  where Self == Observable<Element>? {
    .init(signal: signal, handler: handler)
  }

  static func ?==> (signal: Self,
                    handler: @escaping (Wrapped.Element) -> Void) -> MobecanDisposable
  where Wrapped: ObservableConvertibleType {
    .init(signal: signal, handler: handler)
  }

  static func ?==> (signal: Observable<Void>?,
                    handler: @autoclosure @escaping () -> Void) -> MobecanDisposable
  where Self == Observable<Void>? {
    .init(signal: signal, handler: handler)
  }

  static func ?==> (signal: Self,
                    handler: @autoclosure @escaping () -> Void) -> MobecanDisposable
  where Wrapped: ObservableConvertibleType, Wrapped.Element == Void {
    .init(signal: signal, handler: handler)
  }
}
