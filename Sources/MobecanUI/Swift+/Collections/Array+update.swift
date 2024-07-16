// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {

  func update<Property: Equatable>(_ elements: [Element],
                                   compareBy property: (Element) -> Property) -> [Element] {
    update(
      elements,
      compareBy: { property($0) == property($1) }
    )
  }

  func update(_ elements: [Element],
              compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    map { element in
      elements.first { isSame($0, element) } ?? element
    }
  }

  func update(_ element: Element,
              compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    map {
      isSame($0, element) ? element : $0
    }
  }

  func upsert<Property: Equatable>(_ element: Element,
                                   compareBy property: (Element) -> Property) -> [Element] {
    upsert(
      element,
      compareBy: { property($0) == property($1) }
    )
  }

  func upsert(_ element: Element,
              compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    if contains(where: { isSame($0, element) }) {
      return update(element, compareBy: isSame)
    } else {
      return self + [element]
    }
  }

  func exclude(_ elements: [Element],
               compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    filter { element in
      !elements.contains { isSame($0, element) }
    }
  }

  func exclude(_ element: Element,
               compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    filter { !isSame($0, element) }
  }
}
