// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension ObserverType {

  func filterObserver(_ predicate: @escaping (Element) -> Bool) -> AnyObserver<Element> {
    .onNext {
      if predicate($0) { self.onNext($0) }
    }
  }

  func compactMapObserver<AnotherElement>(_ transform: @escaping (AnotherElement) -> Element?)
  -> AnyObserver<AnotherElement> {
    .onNext {
      transform($0).map { self.onNext($0) }
    }
  }

  func filterNil() -> AnyObserver<Element?> {
    compactMapObserver { $0 }
  }
}
