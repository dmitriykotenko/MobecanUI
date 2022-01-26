// Copyright © 2021 Mobecan. All rights reserved.


public extension Optional {

  func flatten<NestedValue>() -> NestedValue? where Wrapped == NestedValue? {
    flatMap { $0 }
  }
}
