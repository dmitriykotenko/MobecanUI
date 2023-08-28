// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


/// Ошибка, которую вернёт ``Single.retry(until:retryInterval:maximumAttemptsCount:scheduler:operation:)``,
/// если превышено максимальное число попыток или если максимальное число попыток меньше единицы.
public enum RetryError: Error, Equatable {

  case invalidMaximumAttemptsCount(maximumAttemptsCount: Int)
  case noMoreAttempts(maximumAttemptsCount: Int)
}


public extension Single {

  /// Повторяет асинхронную операцию до тех пор, пока не будет выполнено указанное условие,
  /// и возвращает результат последнего повтора.
  ///
  /// Например, эту функцию можно использовать, чтобы повторять один и тот же запрос к серверу до тех пор,
  /// пока он не завершится успешно.
  /// - Parameters:
  ///   - condition: Условие, при выполнении которого надо прекратить повторы и вернуть результат.
  ///   - retryInterval: Интервал между концом предыдущего повтора и началом следующего.
  ///   - maximumAttemptsCount: Максимальное количество повторений.
  ///   - scheduler: Шедулер, который управляет интервалом между повторами.
  ///   - operation: Асинхронная операция, успешного выполнения которой мы хотим добиться.
  /// - Returns: Если удалось выполнить указанное условие, возвращает результат последнего повтора.
  /// - Throws: Если после указанного количества повторений условие всё ещё не выполнено,
  /// возвращает ``RetryError.noMoreAttempts``.
  ///
  /// Если указанное количество повторений меньше единицы,
  /// возвращает ``RetryError.invalidMaximumAttemptsCount``.
  ///
  /// Если при выполнении операции возникла ошибка, возвращает эту ошибку.
  static func retry(until condition: @escaping (Element) -> Bool,
                    retryInterval: Duration,
                    maximumAttemptsCount: Int = Int.max,
                    scheduler: SchedulerType = RxSchedulers.default,
                    operation: @escaping () -> Single<Element>) -> Single<Element> {
    guard maximumAttemptsCount > 0
    else { return .error(RetryError.invalidMaximumAttemptsCount(maximumAttemptsCount: maximumAttemptsCount)) }

    let finalError = RetryError.noMoreAttempts(maximumAttemptsCount: maximumAttemptsCount)

    return Observable.concat(
      Observable
        .deferred {
          operation().asObservable()
            .map {
              if !condition($0) { throw finalError }
              return $0
            }
            .catch { error in
              if (error as? RetryError) == finalError {
                return maximumAttemptsCount == 1 ? .error(finalError) : .empty()
              } else {
                return .error(error)
              }
            }
        },
      Single
        .deferred {
          Single.voidTimer(retryInterval, scheduler: scheduler)
            .flatMap { operation() }
            .map {
              if !condition($0) { throw finalError }
              return $0
            }
        }
        .retry(maximumAttemptsCount - 1)
        .asObservable()
    )
    .take(1)
    .asSingle()
  }
}


public extension Single {
  
  static func retryUntilSuccess<Value, SomeError: Error>(retryInterval: Duration,
                                                         maximumAttemptsCount: Int = Int.max,
                                                         scheduler: SchedulerType = RxSchedulers.default,
                                                         operation: @escaping () -> Single<Element>) -> Single<Value>
  where Element == Result<Value, SomeError> {
    retry(
      until: { $0.isSuccess },
      retryInterval: retryInterval,
      maximumAttemptsCount: maximumAttemptsCount,
      scheduler: scheduler,
      operation: operation
    )
    .asObservable()
    .filterSuccess()
    .asSingle()
  }

  static func retry<Value, SomeError: Error & Equatable>(untilSuccessOr error: SomeError,
                                                         retryInterval: Duration,
                                                         maximumAttemptsCount: Int = Int.max,
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
      maximumAttemptsCount: maximumAttemptsCount,
      scheduler: scheduler,
      operation: operation
    )
  }
}
