// Copyright © 2021 Mobecan. All rights reserved.


public struct Predicate<Value> {

  public var check: (Value) -> Bool

  public init(check: @escaping (Value) -> Bool) {
    self.check = check
  }

  public func callAsFunction(_ value: Value) -> Bool {
    check(value)
  }
}


public extension Predicate {

  static func never() -> Self { .init { _ in false } }

  static func always() -> Self { .init { _ in true } }

  static func not(_ that: Self) -> Self {
    .init { !that($0) }
  }

  func or(_ that: Self) -> Self {
    .init { check($0) || that.check($0) }
  }

  func and(_ that: Self) -> Self {
    .init { check($0) && that.check($0) }
  }

  static func isNil<NestedValue>() -> Self where Value == NestedValue? {
    .init { $0 == nil }
  }

  static func isNotNil<NestedValue>() -> Self where Value == NestedValue? {
    not(.isNil())
  }

  static func isEmpty<Element>() -> Self where Value: Collection, Value.Element == Element {
    .init { $0.isEmpty }
  }

  static func isNotEmpty<Element>() -> Self where Value: Collection, Value.Element == Element {
    not(.isEmpty())
  }

  static func isNilOrEmpty<SomeCollection: Collection>() -> Self where Value == SomeCollection? {
    .init { $0?.isEmpty ?? true }
  }

  static func `is`(_ values: [Value]) -> Self where Value: Equatable {
    .init { values.contains($0) }
  }

  static func `is`(_ values: Set<Value>) -> Self where Value: Hashable {
    .init { values.contains($0) }
  }
}
