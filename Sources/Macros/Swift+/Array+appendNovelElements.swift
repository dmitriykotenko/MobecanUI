// Copyright © 2024 Mobecan. All rights reserved.


extension Array {

  /// Добавляет те элементы нового массива, которых ещё нет в старом массиве.
  mutating func appendNovelElements(from other: some Sequence<Element>,
                                    compareBy isSame: (Element, Element) -> Bool) {
    append(
      contentsOf: other.filterNot { element in contains { isSame($0, element) } }
    )
  }

  /// Добавляет те элементы нового массива, которых ещё нет в старом массиве.
  func appendingNovelElements(from other: some Sequence<Element>,
                              compareBy isSame: (Element, Element) -> Bool) -> [Element] {
    var result = self
    result.appendNovelElements(from: other, compareBy: isSame)
    return result
  }

  /// Добавляет те элементы нового массива, которых ещё нет в старом массиве.
  mutating func appendNovelElements(from other: some Sequence<Element>) where Element: Equatable {
    appendNovelElements(from: other, compareBy: ==)
  }

  /// Добавляет те элементы нового массива, которых ещё нет в старом массиве.
  func appendingNovelElements(from other: some Sequence<Element>) -> [Element] where Element: Equatable {
    var result = self
    result.appendNovelElements(from: other)
    return result
  }
}
