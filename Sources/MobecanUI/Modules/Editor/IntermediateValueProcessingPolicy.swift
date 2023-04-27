// Copyright © 2023 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime
import UIKit


/// Правила обработки промежуточного значения в ``EditorModule``.
public struct IntermediateValueProcessingPolicy<Value, SomeError: Error> {

  /// Минимальный интервал между двумя соседними обработками промежуточного значения.
  public var throttlingDuration: Duration

  /// Обработчик промежуточного значения.
  ///
  /// Если обработка не требуется, возвращает nil.
  public var processValue: (SoftResult<Value, SomeError>) -> Single<Result<Value, SomeError>>?

  public init(throttlingDuration: Duration,
              processValue: @escaping (SoftResult<Value, SomeError>) -> Single<Result<Value, SomeError>>?) {
    self.throttlingDuration = throttlingDuration
    self.processValue = processValue
  }
}
