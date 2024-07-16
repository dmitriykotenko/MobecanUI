// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func orderedPartition(_ predicate: (Element) -> Bool) -> ([Element], [Element]) {
    (filter(predicate), filterNot(predicate))
  }
}
