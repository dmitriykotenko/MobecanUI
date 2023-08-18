// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


public extension Single {
  
  static func retry(until condition: @escaping (Element) -> Bool,
                    retryInterval: Duration,
                    scheduler: SchedulerType = RxSchedulers.default,
                    operation: @escaping () -> Single<Element>) -> Single<Element> {
    operation().flatMap {
      .if(
        condition($0),
        then: .just($0),
        else: Single.just(())
          .delay(retryInterval, scheduler: scheduler)
          .flatMap {
            retry(
              until: condition,
              retryInterval: retryInterval,
              scheduler: scheduler,
              operation: operation
            )
          }
      )
    }
  }
}


public extension Single {
  
  static func retryUntilSuccess<Value, SomeError: Error>(retryInterval: Duration,
                                                         scheduler: SchedulerType = RxSchedulers.default,
                                                         operation: @escaping () -> Single<Element>) -> Single<Value>
  where Element == Result<Value, SomeError> {
    retry(
      until: { $0.isSuccess },
      retryInterval: retryInterval,
      scheduler: scheduler,
      operation: operation
    )
    .asObservable()
    .filterSuccess()
    .asSingle()
  }

  static func retry<Value, SomeError: Error & Equatable>(untilSuccessOr error: SomeError,
                                                         retryInterval: Duration,
                                                         scheduler: SchedulerType = RxSchedulers.default,
                                                         operation: @escaping () -> Single<Element>) -> Single<Element>
  where Element == Result<Value, SomeError> {
    retry(
      until: {
        switch $0 {
        case .success, .failure(error):
          return true
        default:
          return false
        }
      },
      retryInterval: retryInterval,
      scheduler: scheduler,
      operation: operation
    )
  }
}
