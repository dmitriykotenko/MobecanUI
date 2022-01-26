// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public extension Single {

  static func `if`(_ condition: Bool,
                   then firstOperation: @autoclosure () -> Self,
                   else secondOperation: @autoclosure () -> Self) -> Self {
    condition ? firstOperation() : secondOperation()
  }
}
