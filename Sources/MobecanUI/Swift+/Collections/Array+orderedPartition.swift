//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func orderedPartition(_ predicate: (Element) -> Bool) -> ([Element], [Element]) {
    return (filter(predicate), filterNot(predicate))
  }
  
  private func filterNot(_ predicate: (Element) -> Bool) -> [Element] {
    return filter { !predicate($0) }
  }
}
