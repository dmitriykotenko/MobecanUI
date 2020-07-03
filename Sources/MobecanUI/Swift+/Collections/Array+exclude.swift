//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func exclude<Property: Equatable>(_ that: [Element],
                                    compareBy property: (Element) -> Property) -> [Element] {
    filter { element in
      !that.contains { property($0) == property(element) }
    }
  }
  
  func exclude<Property: Equatable>(_ element: Element,
                                    compareBy property: (Element) -> Property) -> [Element] {
    filter {
      property($0) != property(element)
    }
  }
}


public extension Array where Element: Equatable {
  
  func exclude(_ that: [Element]) -> [Element] {
    filter { !that.contains($0) }
  }
}
