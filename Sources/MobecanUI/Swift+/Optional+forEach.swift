// Copyright © 2020 Mobecan. All rights reserved.


public extension Optional {

  func forEach(_ operation: (Wrapped) -> Void) {
    _ = map(operation)
  }
}
