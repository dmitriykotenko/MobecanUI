// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public extension AnyObserver {
  
  static func onNext(handler: @escaping (Element) -> Void) -> AnyObserver<Element> {
    AnyObserver<Element> {
      if case .next(let element) = $0 {
        handler(element)
      }
    }
  }
}
