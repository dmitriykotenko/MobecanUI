// Copyright © 2024 Mobecan. All rights reserved.


extension Optional {

  var asSequence: [Wrapped] { map { [$0] } ?? [] }

  func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
    flatMap { predicate($0) ? $0 : nil }
  }

  func filterNot(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
    filter { !predicate($0) }
  }
}
