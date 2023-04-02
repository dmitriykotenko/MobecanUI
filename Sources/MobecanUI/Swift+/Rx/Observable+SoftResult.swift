// Copyright © 2023 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public extension Observable {

  func filterSuccess<Value, SomeError>() -> Observable<Value> where Element == SoftResult<Value, SomeError> {
    compactMap {
      switch $0 {
      case .success(let value):
        return value
      case .hybrid, .failure:
        return nil
      }
    }
  }

  func filterNonSuccess<Value, SomeError>() -> Observable<SomeError> where Element == SoftResult<Value, SomeError> {
    compactMap {
      switch $0 {
      case .success:
        return nil
      case .hybrid(_, let error), .failure(let error):
        return error
      }
    }
  }

  func filterFailure<Value, SomeError>() -> Observable<SomeError> where Element == SoftResult<Value, SomeError> {
    compactMap {
      switch $0 {
      case .success, .hybrid:
        return nil
      case .failure(let error):
        return error
      }
    }
  }

  func filterNonFailure<Value, SomeError>() -> Observable<Value> where Element == SoftResult<Value, SomeError> {
    compactMap {
      switch $0 {
      case .success(let value):
        return value
      case .hybrid(let value, _):
        return value
      case .failure:
        return nil
      }
    }
  }
}
