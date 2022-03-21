// Copyright © 2020 Mobecan. All rights reserved.


public extension Array {
  
  func mapFirst<A1, B, A2>(_ transform: @escaping (A1) -> A2)-> [(A2, B)] where Element == (A1, B) {
    
    map { (transform($0.0), $0.1) }
  }
  
  func mapSecond<A, B1, B2>(_ transform: @escaping (B1) -> B2)-> [(A, B2)] where Element == (A, B1) {
    
    map { ($0.0, transform($0.1)) }
  }

  func swapped<A, B>() -> [(B, A)] where Element == (A, B) {
    map { ($1, $0) }
  }
}
