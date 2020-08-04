//  Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func paired(with that: [Element],
              by condition: @escaping (Element, Element) -> Bool) -> [(Element, Element)] {
    compactMap { element in
      that.first { condition(element, $0) }.map { otherElement in (element, otherElement) }
    }
  }
}
