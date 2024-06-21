// Copyright © 2024 Mobecan. All rights reserved.


public extension Array {

  /// Массив без последнего элемента.
  var head: Array { dropLast().asArray }

  /// Массив без первого элемента.
  var tail: Array { dropFirst().asArray }

  /// Все «хвосты» массива — то есть непустые подмассивы,
  /// которые начинаются с какого-то элемента массива и идут до самого конца.
  /// (Сам массив не считается своим «хвостом»).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].tails == [[2, 3, 4], [3, 4], [4]]
  /// [1, 2].tails == [[2]]
  /// [1].tails == []
  /// [].tails == []
  /// ```
  var tails: [Self] {
    count <= 1 ?
      [] :
      (0..<(count - 1)).map { Array(self[($0 + 1)...]) }
  }

  /// Все «хвосты», включая сам массив (если он не пустой).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].tailsIncludingSelf == [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4]]
  /// [1, 2].tailsIncludingSelf == [[1, 2], [2]]
  /// [1].tailsIncludingSelf == [[1]]
  /// [].tailsIncludingSelf == []
  /// ```
  var tailsIncludingSelf: [Self] {
    isEmpty ? [] : [self] + tails
  }

  /// Все «головы» массива — то есть непустые подмассивы,
  /// которые начинаются с начала массива и идут до какого-то элемента.
  /// (Сам массив не считается своей «головой»).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].heads == [[1], [1, 2], [1, 2, 3]]
  /// [1, 2].heads == [[1]]
  /// [1].heads == []
  /// [].heads == []
  /// ```
  var heads: [Self] {
    count <= 1 ?
      [] :
      (0..<(count - 1)).map { Array(self[...$0]) }
  }

  /// Все «головы», включая сам массив (если он не пустой).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].headsIncludingSelf == [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4]]
  /// [1, 2].headsIncludingSelf == [[1], [1, 2]]
  /// [1].headsIncludingSelf == [[1]]
  /// [].headsIncludingSelf == []
  /// ```
  var headsIncludingSelf: [Self] {
    isEmpty ? [] : heads + [self]
  }
}
