// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension ObservableType {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> Observable<SoftResult<Value, AnotherError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.mapError(transform) }
  }
}



public extension SharedSequenceConvertibleType {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> SharedSequence<SharingStrategy, SoftResult<Value, AnotherError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.mapError(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> Single<SoftResult<Value, AnotherError>>
  where Element == SoftResult<Value, SomeError> {

    map { $0.mapError(transform) }
  }
}
