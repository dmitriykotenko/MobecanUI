// Copyright © 2024 Mobecan. All rights reserved.


extension Sequence {

  func distinctUntil(_ areEqual: (Element, Element) -> Bool) -> [Element] {
    var result: [Element] = []

    var iterator = makeIterator()

    while let next = iterator.next() {
      if !result.contains(where: { areEqual($0, next) }) {
        result.append(next)
      }
    }

    return result
  }
}


extension Sequence where Element: Equatable {

  var distinct: [Element] { distinctUntil(==) }
}
