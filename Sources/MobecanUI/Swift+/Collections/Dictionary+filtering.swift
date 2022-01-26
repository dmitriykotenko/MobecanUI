// Copyright © 2020 Mobecan. All rights reserved.


// swiftlint:disable unused_closure_parameter
public extension Dictionary {
  
  func filterKeys(_ predicate: @escaping (Key) -> Bool) -> [Key: Value] {
    Dictionary(
      uniqueKeysWithValues: filter { key, value in predicate(key) == true }
    )
  }
  
  func filterValues(_ predicate: @escaping (Value) -> Bool) -> [Key: Value] {
    Dictionary(
      uniqueKeysWithValues: filter { key, value in predicate(value) == true }
    )
  }
}
