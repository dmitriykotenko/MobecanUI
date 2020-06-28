//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public extension Single {
  
  func flatMapSuccess<A, B, SomeError: Error & Equatable>(transform: @escaping (A) -> Single<Result<B, SomeError>>)
    -> Single<Result<B, SomeError>>
    where Element == Result<A, SomeError>, Trait == SingleTrait {
      return flatMap {
        switch $0 {
        case .success(let value):
          return transform(value)
        case .failure(let error):
          return .just(.failure(error))
        }
      }
  }
  
  func flatMapFailure<Value, SomeError: Error & Equatable>(_ error: SomeError,
                             failureHandler: @escaping () -> Self) -> Self
    where Element == Result<Value, SomeError>, Trait == SingleTrait {
      return flatMap {
        switch $0 {
        case .failure(let someError) where someError == error:
          return failureHandler()
        default:
          return .just($0)
        }
      }
  }
  
  func flatMapFailure<Value, SomeError: Error>(failureHandler: @escaping (SomeError) -> Self) -> Self
    where Element == Result<Value, SomeError>, Trait == SingleTrait {
      return flatMap {
        switch $0 {
        case .failure(let error):
          return failureHandler(error)
        default:
          return .just($0)
        }
      }
  }
}