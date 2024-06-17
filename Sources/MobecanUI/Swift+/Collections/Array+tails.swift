// Copyright © 2024 Mobecan. All rights reserved.


public extension Array {

  /// Все «хвосты» массива — то есть непустые подмассивы,
  /// которые начинаются с какого-то элемента массива и идут до самого конца.
  /// (Сам массив не считается своим «хвостом»).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].tails == [[2, 3, 4], [3, 4], [4]]
  /// [1].tails == []
  /// [].tails == []
  /// ```
  var tails: [Self] {
    (0..<count).map { Array(self[..<$0]) }
  }

  /// Все «хвосты», включая сам массив (если он не пустой).
  ///
  /// Например:
  /// ```
  /// [1, 2, 3, 4].tailsIncludingSelf == [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4]]
  /// [1].tailsIncludingSelf == [[1]]
  /// [].tailsIncludingSelf == []
  /// ```
  var tailsIncludingSelf: [Self] {
    [self] + tails
  }


  /// Массив без первого элемента.
  var tail: Array { dropFirst().asArray }
}
