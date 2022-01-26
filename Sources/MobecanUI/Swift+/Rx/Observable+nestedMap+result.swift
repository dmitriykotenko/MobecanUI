// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension Observable {
  
  func nestedMap<Value, SomeError, AnotherValue>(transform: @escaping (Value) -> AnotherValue)
    -> Observable<Result<AnotherValue, SomeError>>
    where Element == Result<Value, SomeError> {

    map { $0.map(transform) }
  }
  
  func nestedFlatMap<Value, SomeError, AnotherValue>(transform: @escaping (Value) -> Result<AnotherValue, SomeError>)
    -> Observable<Result<AnotherValue, SomeError>>
    where Element == Result<Value, SomeError> {

    map { $0.flatMap(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {
  
  func nestedMap<Value, SomeError, AnotherValue>(transform: @escaping (Value) -> AnotherValue)
  -> Single<Result<AnotherValue, SomeError>>
  where Element == Result<Value, SomeError> {
      
    map { $0.map(transform) }
  }
  
  func nestedFlatMap<Value, SomeError, AnotherValue>(transform: @escaping (Value) -> Result<AnotherValue, SomeError>)
  -> Single<Result<AnotherValue, SomeError>>
  where Element == Result<Value, SomeError> {
      
    map { $0.flatMap(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == MaybeTrait {
  
  func maybeNestedMap<Value, SomeError, AnotherValue>(transform: @escaping (Value) -> AnotherValue)
  -> Maybe<Result<AnotherValue, SomeError>>
  where Element == Result<Value, SomeError> {
      
    map { $0.map(transform) }
  }
}
