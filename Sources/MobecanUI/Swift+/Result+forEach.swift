//  Copyright © 2020 Mobecan. All rights reserved.


extension Result {

  func forEach(_ operation: (Success) -> Void) {
    _ = map(operation)
  }
}
