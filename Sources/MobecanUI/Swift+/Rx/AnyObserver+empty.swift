// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension AnyObserver {

  static var empty: AnyObserver<Element> {
    onNext { _ in }
  }
}
