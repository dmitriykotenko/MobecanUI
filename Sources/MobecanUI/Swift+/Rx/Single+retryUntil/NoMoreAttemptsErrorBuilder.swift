// Copyright © 2023 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime


struct NoMoreAttemptsErrorBuilder<Value> {

  private let maximumAttemptsCount: Int

  var attemptNumber: Int

  init(maximumAttemptsCount: Int,
       attemptNumber: Int) {
    self.maximumAttemptsCount = maximumAttemptsCount
    self.attemptNumber = attemptNumber
  }

  func callAsFunction(value: Value) -> NoMoreAttemptsError<Value> {
    .init(
      maximumAttemptsCount: maximumAttemptsCount,
      lastAttempt: (number: attemptNumber, result: .success(value))
    )
  }

  func callAsFunction(nestedError: Error) -> NoMoreAttemptsError<Value> {
    .init(
      maximumAttemptsCount: maximumAttemptsCount,
      lastAttempt: (number: attemptNumber, result: .failure(nestedError))
    )
  }

  func wrapIfNecessary(error: Error) -> NoMoreAttemptsError<Value> {
    (error as? NoMoreAttemptsError<Value>) ?? self(nestedError: error)
  }
}
