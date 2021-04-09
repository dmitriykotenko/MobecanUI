//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func prefixUpTo(_ predicate: (Element) -> Bool) -> [Element] {
    foldWhile([]) { array, element in
      predicate(element) ? .stop(array + [element]) : .next(array + [element])
    }
  }
}


public extension Array where Element: Equatable {
  
  func prefix(upToElement element: Element) -> [Element] {
    prefixUpTo { $0 == element }
  }
}
