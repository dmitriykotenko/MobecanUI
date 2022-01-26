// Copyright © 2020 Mobecan. All rights reserved.


public extension Array where Element: Equatable {

  func firstElement(after element: Element) -> Element? {
    drop { $0 != element }.drop { $0 == element }.first
  }

  func lastElement(before element: Element) -> Element? {
    reversed().firstElement(after: element)
  }
}
