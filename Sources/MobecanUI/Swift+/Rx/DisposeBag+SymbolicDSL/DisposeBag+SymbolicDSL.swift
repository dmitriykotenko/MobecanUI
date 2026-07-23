// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension DisposeBag {

  func callAsFunction(@DisposablesResultBuilder disposables: () -> [MobecanDisposable]) {
    disposables()
      .compactMap { $0.build(nil) }
      .disposed(by: self)
  }

  func callAsFunction(_ scheduler: SchedulerType,
                      @DisposablesResultBuilder disposables: () -> [MobecanDisposable]) {
    disposables()
      .compactMap { $0.build(scheduler) }
      .disposed(by: self)
  }
}


@resultBuilder
public class DisposablesResultBuilder {

  public static func buildExpression(_ disposable: Disposable) -> MobecanDisposable {
    .init(disposable)
  }

  public static func buildExpression(_ disposable: MobecanDisposable) -> MobecanDisposable {
    disposable
  }

  public static func buildBlock(_ components: MobecanDisposable...) -> [MobecanDisposable] {
    components
  }
}


infix operator ==> : DefaultPrecedence
infix operator ?==> : DefaultPrecedence

public extension Observable {

  static func ==> <Observer: ObserverType>(signal: Observable<Element>,
                                           listener: Observer) -> MobecanDisposable
  where Observer.Element == Element {
    .init(signal: signal, listener: listener)
  }

  static func ==> <Observer: ObserverType>(signal: Observable<Element>,
                                           listener: Observer) -> MobecanDisposable
  where Observer.Element == Element? {
    .init(optionalSignal: signal, listener: listener)
  }
}

public extension Optional {

  static func ?==> <Element, Observer: ObserverType>(signal: Observable<Element>?,
                                                     listener: Observer) -> MobecanDisposable
  where Self == Observable<Element>?, Observer.Element == Element {
    .init(signal: signal, listener: listener)
  }

  static func ?==> <Element, Observer: ObserverType>(signal: Observable<Element>?,
                                                     listener: Observer) -> MobecanDisposable
  where Self == Observable<Element?>?, Observer.Element == Element? {
    .init(optionalSignal: signal, listener: listener)
  }
}


public extension ObservableConvertibleType {

  static func ==> <Observer: ObserverType>(signal: Self,
                                           listener: Observer) -> MobecanDisposable
  where Observer.Element == Element {
    .init(signal: signal, listener: listener)
  }

  static func ==> <Observer: ObserverType>(signal: Self,
                                           listener: Observer) -> MobecanDisposable
  where Observer.Element == Element? {
    .init(optionalSignal: signal, listener: listener)
  }
}


public extension Optional {

  static func ?==> <Observer: ObserverType>(signal: Self,
                                            listener: Observer) -> MobecanDisposable
  where Wrapped: ObservableConvertibleType, Observer.Element == Wrapped.Element {
    .init(signal: signal, listener: listener)
  }

  static func ?==> <Observer: ObserverType>(signal: Self,
                                            listener: Observer) -> MobecanDisposable
  where Wrapped: ObservableConvertibleType, Observer.Element == Wrapped.Element? {
    .init(optionalSignal: signal, listener: listener)
  }
}


infix operator <== : DefaultPrecedence
infix operator <==? : DefaultPrecedence

public extension ObserverType {

  static func <== (listener: Self,
                   signal: Observable<Element>) -> MobecanDisposable {
    .init(signal: signal, listener: listener)
  }

  static func <== <NestedElement>(listener: Self,
                                  signal: Observable<NestedElement>) -> MobecanDisposable
  where Element == NestedElement? {
    .init(optionalSignal: signal, listener: listener)
  }

  static func <== <Source: ObservableConvertibleType>(listener: Self,
                                                      signal: Source) -> MobecanDisposable
  where Source.Element == Element {
    .init(signal: signal, listener: listener)
  }

  static func <== <Source: ObservableConvertibleType>(listener: Self,
                                                      signal: Source) -> MobecanDisposable
  where Element == Source.Element? {
    .init(optionalSignal: signal, listener: listener)
  }

  static func <==? (listener: Self,
                    signal: Observable<Element>?) -> MobecanDisposable {
    .init(signal: signal, listener: listener)
  }

  static func <==? <NestedElement>(listener: Self,
                                   signal: Observable<NestedElement>?) -> MobecanDisposable
  where Element == NestedElement? {
    .init(optionalSignal: signal, listener: listener)
  }

  static func <==? <Source: ObservableConvertibleType>(listener: Self,
                                                       signal: Source?) -> MobecanDisposable
  where Source.Element == Element {
    .init(signal: signal, listener: listener)
  }

  static func <==? <Source: ObservableConvertibleType>(listener: Self,
                                                       signal: Source?) -> MobecanDisposable
  where Element == Source.Element? {
    .init(optionalSignal: signal, listener: listener)
  }
}
