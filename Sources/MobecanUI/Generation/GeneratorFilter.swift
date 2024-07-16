// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


public struct GeneratorFilter<Value> {

  public var validate: (Value) -> GeneratorResult<Value>

  public func callAsFunction(_ value: Value) -> GeneratorResult<Value> {
    validate(value)
  }

  init(validate: @escaping (Value) -> GeneratorResult<Value>) {
    self.validate = validate
  }

  func combine(with other: Self) -> Self {
    .init {
      self($0).flatMap { other($0) }
    }
  }

  public static func isNotEqual(to value: Value) -> Self where Value: Equatable {
    .init {
      $0 == value ?
        .failure(.init(message: "\($0) is equal to \(value)")) :
        .success($0)
    }
  }

  public static func alwaysSuccess() -> Self {
    .init { .success($0) }
  }
}
