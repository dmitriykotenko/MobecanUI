// Copyright © 2024 Mobecan. All rights reserved.


public extension Sequence {

  func elementsWith<Property: Hashable>(duplicated property: (Element) -> Property) -> [[Element]] {
    let groups = Dictionary(grouping: self.asArray, by: property)

    return groups.values.filter { $0.count > 1 }
  }

  func hasDuplicated<Property: Hashable>(_ property: (Element) -> Property) -> Bool {
    elementsWith(duplicated: property).isNotEmpty
  }
}
