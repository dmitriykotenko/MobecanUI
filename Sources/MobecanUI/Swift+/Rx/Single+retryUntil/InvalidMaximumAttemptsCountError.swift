// Copyright © 2023 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


/// Ошибка, которую вернёт ``Single.retry(until:retryInterval:maximumAttemptsCount:scheduler:operation:)``,
/// если указанное максимальное число повторов меньше единицы.
public struct InvalidMaximumAttemptsCountError: Error {

  /// Указанное максимальное количество повторов.
  public let maximumAttemptsCount: Int
}
