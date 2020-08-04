//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func filter<Property: Equatable>(property keyPath: KeyPath<Element, Property>,
                                   among other: [Property]) -> [Element] {
    filter { other.contains($0[keyPath: keyPath]) }
  }
  
  func filter<Property: Hashable>(property keyPath: KeyPath<Element, Property>,
                                  among other: Set<Property>) -> [Element] {
    filter { other.contains($0[keyPath: keyPath]) }
  }
}


public extension Array where Element: Equatable {
  
  func filterBy(_ other: [Element]) -> [Element] {
    filter { other.contains($0) }
  }
}


public extension Array where Element: Hashable {
  
  func filterBy(_ other: Set<Element>) -> [Element] {
    filter { other.contains($0) }
  }
}
