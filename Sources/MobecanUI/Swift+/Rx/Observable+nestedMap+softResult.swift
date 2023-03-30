// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension ObservableType {

  func nestedMap<Value, SomeError, AnotherValue>(_ transform: @escaping (Value) -> AnotherValue)
  -> Observable<SoftResult<AnotherValue, SomeError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.map(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func nestedMap<Value, SomeError, AnotherValue>(_ transform: @escaping (Value) -> AnotherValue)
  -> Single<SoftResult<AnotherValue, SomeError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.map(transform) }
  }
}


public extension SharedSequenceConvertibleType {

  func nestedMap<Value, SomeError, AnotherValue>(_ transform: @escaping (Value) -> AnotherValue)
  -> SharedSequence<SharingStrategy, SoftResult<AnotherValue, SomeError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.map(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == MaybeTrait {

  func maybeNestedMap<Value, SomeError, AnotherValue>(_ transform: @escaping (Value) -> AnotherValue)
  -> Maybe<SoftResult<AnotherValue, SomeError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.map(transform) }
  }
}
