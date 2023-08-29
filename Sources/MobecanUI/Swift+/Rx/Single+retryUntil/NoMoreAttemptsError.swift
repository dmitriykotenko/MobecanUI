// Copyright © 2023 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


/// Ошибка, которую вернёт ``Single.retry(until:retryInterval:maximumAttemptsCount:scheduler:operation:)``,
/// если превышено максимальное число повторов.
public struct NoMoreAttemptsError<Value>: Error {

  /// Максимальное количество повторов.
  public let maximumAttemptsCount: Int

  /// Номер и результат последнего повтора. Нумерация начинается с единицы.
  public let lastAttempt: (number: Int, result: Result<Value, Error>)
}
