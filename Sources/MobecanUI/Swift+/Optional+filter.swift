// Copyright © 2020 Mobecan. All rights reserved.


public extension Optional {
  
  func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
    flatMap { predicate($0) ? $0 : nil }
  }

  func filterNot(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
    filter { !predicate($0) }
  }
}
