//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension DisposeBag {

  func callAsFunction(@DisposablesResultBuilder disposables: () -> [Disposable]) {
    disposables().disposed(by: self)
  }
}


@resultBuilder
public class DisposablesResultBuilder {

  public static func buildBlock(_ components: Disposable...) -> [Disposable] {
    components
  }
}


infix operator ==> : DefaultPrecedence

public extension Observable {

  static func ==> <Observer: ObserverType>(signal: Observable<Element>, listener: Observer) -> Disposable
  where Observer.Element == Element {
    signal.bind(to: listener)
  }

  static func ==> <Observer: ObserverType>(signal: Observable<Element>, listener: Observer) -> Disposable
  where Observer.Element == Element? {
    signal.bind(to: listener)
  }
}


public extension ObservableType {

  static func ==> <Observer: ObserverType>(signal: Self, listener: Observer) -> Disposable
  where Observer.Element == Element {
    signal.bind(to: listener)
  }

  static func ==> <Observer: ObserverType>(signal: Self, listener: Observer) -> Disposable
  where Observer.Element == Element? {
    signal.bind(to: listener)
  }
}


public extension ObservableConvertibleType {

  static func ==> <Observer: ObserverType>(signal: Self, listener: Observer) -> Disposable
  where Observer.Element == Element {
    signal.asObservable().bind(to: listener)
  }

  static func ==> <Observer: ObserverType>(signal: Self, listener: Observer) -> Disposable
  where Observer.Element == Element? {
    signal.asObservable().bind(to: listener)
  }
}


infix operator <== : DefaultPrecedence

public extension ObserverType {

  static func <== (listener: Self, signal: Observable<Element>) -> Disposable {
    signal.bind(to: listener)
  }

  static func <== <NestedElement>(listener: Self, signal: Observable<NestedElement>) -> Disposable
  where Element == NestedElement? {
    signal.bind(to: listener)
  }

  static func <== <Source: ObservableType>(listener: Self, signal: Source) -> Disposable
  where Source.Element == Element {
    signal.bind(to: listener)
  }

  static func <== <Source: ObservableType>(listener: Self, signal: Source) -> Disposable
  where Element == Source.Element? {
    signal.bind(to: listener)
  }

  static func <== <Source: ObservableConvertibleType>(listener: Self, signal: Source) -> Disposable
  where Source.Element == Element {
    signal.asObservable().bind(to: listener)
  }

  static func <== <Source: ObservableConvertibleType>(listener: Self, signal: Source) -> Disposable
  where Element == Source.Element? {
    signal.asObservable().bind(to: listener)
  }
}
