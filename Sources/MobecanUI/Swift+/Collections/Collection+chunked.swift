//  Copyright © 2020 Mobecan. All rights reserved.


public extension Collection where Index == Int {
  
  func chunked(into size: Int) -> [[Element]] {
    return
      stride(from: 0, to: count, by: size)
        .map {
          Array(self[$0 ..< Swift.min($0 + size, count)])
        }
  }
  
  func chunkedFromRight(into size: Int) -> [[Element]] {
    let shiftAmount = count % size
    let prefix = Array(self[0..<shiftAmount])
    
    let suffix = stride(from: shiftAmount, to: count, by: size)
        .map { Array(self[$0..<($0 + size)]) }
    
    return prefix.isEmpty ? suffix : [prefix] + suffix
  }
}
