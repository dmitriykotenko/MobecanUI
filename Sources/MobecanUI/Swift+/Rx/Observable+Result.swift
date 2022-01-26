// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension Observable {
  
  func filterSuccess<Value, SomeError>() -> Observable<Value> where Element == Result<Value, SomeError> {
    successOrNil().filterNil()
  }
  
  func successOrNil<Value, SomeError>() -> Observable<Value?> where Element == Result<Value, SomeError> {
    map {
      switch $0 {
      case .success(let value):
        return value
      case .failure:
        return nil
      }
    }
  }
  
  func filterFailure<Value, SomeError>() -> Observable<SomeError> where Element == Result<Value, SomeError> {
    failureOrNil().filterNil()
  }
  
  func failureOrNil<Value, SomeError>() -> Observable<SomeError?> where Element == Result<Value, SomeError> {
    map {
      switch $0 {
      case .success:
        return nil
      case .failure(let error):
        return error
      }
    }
  }
  
  func filterSuccessAndNil<Value, SomeError: Error>() -> Observable<Value?>
    where Element == Result<Value, SomeError>? {

      filter {
        switch $0 {
        case .success, nil:
          return true
        case .failure:
          return false
        }
      }
      .map {
        switch $0 {
        case .success(let value):
          return value
        case .failure, nil:
          return nil
        }
      }
  }
}
