//  Copyright © 2021 Mobecan. All rights reserved.


public struct OrderedMultiDictionary<Key: Equatable, Value>: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

  private typealias KeyAndValue = (key: Key, value: Value)

  private var pairs: [KeyAndValue]

  public init(arrayLiteral keysAndValues: (Key, Value)...) {
    pairs = keysAndValues
  }

  public init(dictionaryLiteral keysAndValues: (Key, Value)...) {
    pairs = keysAndValues
  }

  public init(_ keysAndValues: [(Key, Value)]) {
    pairs = keysAndValues
  }

  public var keysAndValues: [(Key, Value)] { pairs }

  public var keys: [Key] { pairs.map {$0.key } }

  public var values: [Value] { pairs.map {$0.value } }

  public mutating func append(value: Value, key: Key) {
    pairs.append((key, value))
  }
}


// MARK: - Equatable conformance
extension OrderedMultiDictionary: Equatable where Value: Equatable {

  public static func == (this: Self, that: Self) -> Bool {
    this.pairs.count == that.pairs.count
    && zip(this.pairs, that.pairs).allSatisfy {
      $0.0 == $1.0 && $0.1 == $1.1
    }
  }
}


// MARK: - Subscripts
public extension OrderedMultiDictionary {

  subscript(_ key: Key) -> Value? {
    get {
      pairs.first { $0.key == key }?.value
    }
    set {
      pairs = pairs.filter { $0.key != key }
      newValue.map { pairs = pairs + [(key, $0)] }
    }
  }

  subscript(all key: Key) -> [Value] {
    pairs.compactMap { $0.key == key ? $0.value : nil }
  }

  subscript(first key: Key) -> Value? {
    pairs.first { $0.key == key }?.value
  }

  subscript(last key: Key) -> Value? {
    pairs.last { $0.key == key }?.value
  }
}


// MARK: - Filtering
public extension OrderedMultiDictionary {

  func filter(_ predicate: (Key, Value) -> Bool) -> Self {
    .init(pairs.filter(predicate))
  }

  func filterKeys(_ predicate: (Key) -> Bool) -> Self {
    filter { key, value in predicate(key) == true }
  }

  func filterValues(_ predicate: (Value) -> Bool) -> Self {
    filter { key, value in predicate(value) == true }
  }
}


// MARK: - Mapping
public extension OrderedMultiDictionary {

  func compactMap<AnotherKey: Equatable, AnotherValue>(
    _ transform: (Key, Value) -> (AnotherKey, AnotherValue)?
  ) -> OrderedMultiDictionary<AnotherKey, AnotherValue> {
    .init(pairs.compactMap(transform))
  }

  func map<AnotherKey: Equatable, AnotherValue>(
    _ transform: (Key, Value) -> (AnotherKey, AnotherValue)
  ) -> OrderedMultiDictionary<AnotherKey, AnotherValue> {
    compactMap(transform)
  }

  func mapKeys<AnotherKey: Equatable>(_ transform: (Key) -> AnotherKey)
    -> OrderedMultiDictionary<AnotherKey, Value> {
      map { (transform($0), $1) }
  }

  func mapValues<AnotherValue>(_ transform: (Value) -> AnotherValue)
    -> OrderedMultiDictionary<Key, AnotherValue> {
      map { ($0, transform($1)) }
  }
}


// MARK: - Swapping
public extension OrderedMultiDictionary where Value: Equatable {

  func swapped() -> OrderedMultiDictionary<Value, Key> {
    .init(keysAndValues.swapped())
  }
}


// MARK: - Hashable keys
extension OrderedMultiDictionary where Key: Hashable {

  public init(_ dictionary: [Key: Value]) {
    pairs = dictionary.map { $0 }
  }

  public var unorderedKeys: Set<Key> {
    Set(pairs.map { $0.key })
  }

  public var asDictionary: [Key: [Value]] {
    Dictionary(
      uniqueKeysWithValues: unorderedKeys.map { ($0, self[all: $0]) }
    )
  }
}


// MARK: - Array to OrderedMultiDictionary
public extension Array {

  func asOrderedMultiDictionary<Key: Equatable, Value>() -> OrderedMultiDictionary<Key, Value>
    where Element == (Key, Value) {

      OrderedMultiDictionary(self)
  }
}
