//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


public extension Single {
  
  static func retry(until condition: @escaping (Element) -> Bool,
                    retryInterval: Duration,
                    operation: @escaping () -> Single<Element>) -> Single<Element> {
    return operation()
      .flatMap {
        condition($0) ?
          Single.just($0) :
          Single.just(())
            .delay(retryInterval, scheduler: MainScheduler.instance)
            .flatMap { retry(until: condition, retryInterval: retryInterval, operation: operation) }
      }
  }
}


public extension Single {
  
  static func retryUntilSuccess<Value, SomeError: Error>(retryInterval: Duration,
                                                         operation: @escaping () -> Single<Element>) -> Single<Element>
    where Element == Result<Value, SomeError> {

      return retry(
        until: {
          switch $0 {
          case .success:
            return true
          case .failure:
            return false
          }
        },
        retryInterval: retryInterval,
        operation: operation
      )
  }

  static func retry<Value, SomeError: Error & Equatable>(untilSuccessOr error: SomeError,
                           retryInterval: Duration,
                           operation: @escaping () -> Single<Element>) -> Single<Element>
    where Element == Result<Value, SomeError> {
      
      return retry(
        until: {
          switch $0 {
          case .success, .failure(error):
            return true
          default:
            return false
          }
        },
        retryInterval: retryInterval,
        operation: operation
      )
  }
}
