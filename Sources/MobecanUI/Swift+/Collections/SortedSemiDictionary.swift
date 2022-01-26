// Copyright © 2020 Mobecan. All rights reserved.


public struct SortedSemiDictionary<Key: Hashable, SemiKey, Value> {
  
  public typealias Pair = (SemiKey, Value)
  
  public var sortedKeys: [Key] = []
  
  public var pairs: [Key: Pair]
  
  public var semiPairs: [Pair] { sortedKeys.compactMap { pairs[$0] } }
  
  public var values: [Value] { Array(semiPairs.map { $0.1 }) }
  
  public let keyExtractor: (SemiKey) -> Key
  
  public static func empty(keyExtractor: @escaping (SemiKey) -> Key) -> SortedSemiDictionary<Key, SemiKey, Value> {
    SortedSemiDictionary(
      semiKeysAndValues: [],
      keyExtractor: keyExtractor
    )
  }
  
  public init(semiKeysAndValues: [(SemiKey, Value)],
              keyExtractor: @escaping (SemiKey) -> Key) {
    self.keyExtractor = keyExtractor
    
    self.sortedKeys = semiKeysAndValues.map { keyExtractor($0.0) }
    
    self.pairs = Dictionary(
      uniqueKeysWithValues: semiKeysAndValues.map { (keyExtractor($0.0), $0) }
    )
  }
  
  public func value(semiKey: SemiKey) -> Value? {
    pairs[keyExtractor(semiKey)]?.1
  }
  
  public func with(newSemiKeys: [SemiKey],
                   defaultValue: @escaping (SemiKey) -> Value,
                   updateValue: @escaping (SemiKey, Value) -> Void) -> SortedSemiDictionary<Key, SemiKey, Value> {
    let result = SortedSemiDictionary(
      semiKeysAndValues: newSemiKeys.map {
        ($0, value(semiKey: $0) ?? defaultValue($0))
      },
      keyExtractor: keyExtractor
    )
    
    result.semiPairs.forEach { updateValue($0.0, $0.1) }
    
    return result
  }
}
