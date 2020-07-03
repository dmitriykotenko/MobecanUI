//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func update<Property: Equatable>(_ element: Element,
                                   compareBy property: (Element) -> Property) -> [Element] {
    map {
      property($0) == property(element) ? element : $0
    }
  }
}
