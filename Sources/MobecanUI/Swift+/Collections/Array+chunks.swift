// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {

  func chunks(length: Int) -> [[Element]] {
    stride(from: 0, to: count, by: length)
      .map { Array(dropFirst($0).prefix(length)) }
  }

  func chunksFromRight(length: Int) -> [[Element]] {
    stride(from: 0, to: count, by: length)
      .map { Array(dropLast($0).suffix(length)) }
      .reversed()
  }
}
