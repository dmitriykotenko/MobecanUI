//  Copyright © 2020 Mobecan. All rights reserved.


extension Result {

  func forEach(_ operation: @escaping (Success) -> Void) {
    _ = map(operation)
  }
}
