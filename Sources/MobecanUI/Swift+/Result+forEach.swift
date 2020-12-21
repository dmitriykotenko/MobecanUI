//  Copyright © 2020 Mobecan. All rights reserved.


public extension Result {

  func forEach(_ operation: (Success) -> Void) {
    _ = map(operation)
  }
}
