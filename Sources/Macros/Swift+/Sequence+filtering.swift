// Copyright © 2024 Mobecan. All rights reserved.


extension Sequence {

  func filterNot(_ predicate: (Element) -> Bool) -> [Element] {
    filter { !predicate($0) }
  }

  func filterNil<WrappedElement>() -> [WrappedElement] where Element == WrappedElement? {
    compactMap { $0 }
  }
}
