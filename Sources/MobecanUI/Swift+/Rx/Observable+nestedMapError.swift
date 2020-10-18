//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxOptional
import RxSwift


public extension Observable {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> Observable<Result<Value, AnotherError>>
  where Element == Result<Value, SomeError> {

      map { $0.mapError(transform) }
  }
}



public extension SharedSequenceConvertibleType {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> SharedSequence<SharingStrategy, Result<Value, AnotherError>>
  where Element == Result<Value, SomeError> {

      map { $0.mapError(transform) }
  }
}


public extension PrimitiveSequenceType where Trait == SingleTrait {

  func nestedMapError<Value, SomeError, AnotherError: Error>(_ transform: @escaping (SomeError) -> AnotherError)
  -> Single<Result<Value, AnotherError>>
  where Element == Result<Value, SomeError> {

    map { $0.mapError(transform) }
  }
}
