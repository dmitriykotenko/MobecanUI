//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func orderedPartition(_ predicate: (Element) -> Bool) -> ([Element], [Element]) {
    (filter(predicate), filterNot(predicate))
  }
  
  private func filterNot(_ predicate: (Element) -> Bool) -> [Element] {
    filter { !predicate($0) }
  }
}
