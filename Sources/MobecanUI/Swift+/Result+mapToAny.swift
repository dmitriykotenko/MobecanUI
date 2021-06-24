// Copyright © 2021 Mobecan. All rights reserved.


public extension Result {

  func mapToAny() -> Result<Any, Failure> {
    map { $0 as Any }
  }
}
