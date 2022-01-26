// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension AnyObserver {

  static func fromArray(_ array: [Self]) -> Self {
    AnyObserver { event in
      array.forEach { $0.on(event) }
    }
  }
}
