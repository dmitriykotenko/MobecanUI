//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func prefixUpTo(_ predicate: (Element) -> Bool) -> [Element] {
    return foldWhile([]) { array, element in
      predicate(element) ? .stop(array + [element]) : .next(array + [element])
    }
  }
}


extension Array where Element: Equatable {
  
  func prefix(upToElement element: Element) -> [Element] {
    prefixUpTo { $0 == element }
  }
}
