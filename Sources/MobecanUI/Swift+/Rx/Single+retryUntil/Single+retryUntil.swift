// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


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


public extension Single {

  /// Повторяет асинхронную операцию до тех пор, пока не будет выполнено указанное условие,
  /// и возвращает результат последнего вызова операции.
  ///
  /// Например, эту функцию можно использовать, чтобы повторять один и тот же запрос к серверу до тех пор,
  /// пока он не завершится успешно.
  ///
  /// - Warning: Если при очередном выполнении операции возникла ошибка,
  /// считается, что указанное условие не выполнено.
  ///
  /// - Warning: Сигнал ленивый — все вычисления начинаются после первой подписки
  /// и повторяются заново при каждой новой подписке.
  /// - Parameters:
  ///   - condition: Условие, при выполнении которого надо прекратить повторы и вернуть результат.
  ///   - retryInterval: Интервал между концом предыдущего повтора и началом следующего.
  ///   - maximumAttemptsCount: Максимальное количество повторов. Дефолтное значение равно ``Int.max``.
  ///   - scheduler: Шедулер, который управляет интервалом между повторами.
  ///   - operation: Асинхронная операция, успешного выполнения которой мы хотим добиться.
  /// - Returns: Если удалось выполнить указанное условие, возвращает результат последнего повтора.
  /// - Throws: Если после указанного количества повторов условие всё ещё не выполнено,
  /// возвращает ``NoMoreAttemptsError``.
  ///
  /// Если указанное количество повторов меньше единицы,
  /// возвращает ``InvalidMaximumAttemptsCountError``.
  static func retry(until condition: @escaping (Element) -> Bool,
                    retryInterval: Duration,
                    maximumAttemptsCount: Int = Int.max,
                    scheduler: SchedulerType = RxSchedulers.default,
                    operation: @escaping () -> Single<Element>) -> Single<Element> {
    Observable.deferred {
      if maximumAttemptsCount <= 0 {
        throw InvalidMaximumAttemptsCountError(maximumAttemptsCount: maximumAttemptsCount)
      }

      var buildError = NoMoreAttemptsErrorBuilder<Element>(
        maximumAttemptsCount: maximumAttemptsCount,
        attemptNumber: 0
      )

      return Observable.deferred {
        buildError.attemptNumber += 1

        return Observable.voidTimer(
          (buildError.attemptNumber == 1) ? Duration.zero : retryInterval,
          scheduler: scheduler
        )
        .flatMap { operation() }
        .ifNot(condition, throw: { buildError(value: $0) })
      }
      .retry(maximumAttemptsCount)
      .catch { throw buildError.wrapIfNecessary(error: $0) }
    }
    .take(1)
    .asSingle()
  }
}
