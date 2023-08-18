// Copyright © 2023 Mobecan. All rights reserved.

import Foundation
import RxCocoa
import RxSwift
import SwiftDateTime


public extension ObservableType {

  /// Задержка сигнала, чтобы избежать reentrancy-циклов.
  func observeAsynchronously() -> Observable<Element> {
    observe(on: RxSchedulers.defaultAsyncInstance)
  }

  /// Задержка сигнала, чтобы избежать reentrancy-циклов.
  func observeAsynchronously(qos: DispatchQoS) -> Observable<Element> {
    observe(on: RxSchedulers.asyncInstance(qos: qos))
  }
}


public extension PrimitiveSequence {

  /// Задержка сигнала, чтобы избежать reentrancy-циклов.
  func observeAsynchronously() -> PrimitiveSequence<Trait, Element> {
    observe(on: RxSchedulers.defaultAsyncInstance)
  }

  /// Задержка сигнала, чтобы избежать reentrancy-циклов.
  func observeAsynchronously(qos: DispatchQoS) -> PrimitiveSequence<Trait, Element> {
    observe(on: RxSchedulers.asyncInstance(qos: qos))
  }
}
