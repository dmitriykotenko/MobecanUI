// Copyright © 2024 Mobecan. All rights reserved.


public extension Array {

  /// Все подмассивы указанной длины.
  ///
  /// Например:
  /// ```
  /// [].subarrays(ofLength: 1) == []
  /// [1, 2, 3].subarrays(ofLength: 1) == [[1], [2], [3]]
  /// [1, 2, 3, 4, 5, 6].subarrays(ofLength: 3) == [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6]]
  /// ```
  func subarrays(ofLength length: Int) -> [Self] {
    indices.dropLast(length - 1).map {
      self[$0..<($0 + length)].asArray
    }
  }

  /// Все пары соседних элементов.
  ///
  /// Например:
  /// ```
  /// [].consecutivePairs == []
  /// [1].consecutivePairs == []
  /// [1, 2].consecutivePairs == [(1, 2)]
  /// [1, 2, 3].consecutivePairs == [(1, 2), (2, 3)]
  /// [1, 2, 3, 4, 1, 2].consecutivePairs == [(1, 2), (2, 3), (3, 4), (4, 1), (1, 2)]
  /// ```
  var consecutivePairs: [(Element, Element)] {
    subarrays(ofLength: 2).map { ($0[0], $0[1]) }
  }
}
