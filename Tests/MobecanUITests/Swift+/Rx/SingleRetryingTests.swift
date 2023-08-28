// Copyright © 2023 Mobecan. All rights reserved.

import XCTest
@testable import MobecanUI

import RxSwift
import RxTest
import SwiftDateTime


final class SingleRetryingTests: XCTestCase {

  func testImmediateSuccess() {
    _ = (1...10_000).prefix { _ in
      check(
        operation: { _, _ in .just(true) },
        retryInterval: 5.seconds,
        expectedEvents: [.next(0, true), .completed(0)]
      )
    }
  }

  func testFinalTiming() {
    _ = (1...10_000).prefix { _ in
      let attemptsBeforeSuccess = Int.random(in: 1...10)
      let retryInterval = 5.seconds
      let expectedFinalTime = attemptsBeforeSuccess * 5

      return check(
        operation: { attemptNumber, _ in .just(attemptNumber > attemptsBeforeSuccess) },
        retryInterval: retryInterval,
        expectedEvents: [
          .next(expectedFinalTime, true),
          .completed(expectedFinalTime)
        ]
      )
    }
  }

  func testOperationDelay() {
    _ = (1...10_000).prefix { _ in
      let operationDelay = 3.seconds
      let attemptsBeforeSuccess = Int.random(in: 1...10)
      let retryInterval = 17.seconds

      let expectedFinalTime =
        attemptsBeforeSuccess * retryInterval.seconds
        + (attemptsBeforeSuccess + 1) * operationDelay.seconds

      return check(
        operation: { attemptNumber, scheduler in
          Single
            .just(attemptNumber > attemptsBeforeSuccess)
            .delay(operationDelay.toRxTimeInterval, scheduler: scheduler)
        },
        retryInterval: retryInterval,
        expectedEvents: [.next(expectedFinalTime, true), .completed(expectedFinalTime)]
      )
    }
  }

  func testPositiveMaximumAttemptsCount() {
    _ = (1...10_000).prefix { _ in
      let operationDelay = 3.seconds
      let maximumAttemptsCount = Int.random(in: 1...10)
      let retryInterval = 17.seconds

      let expectedFinalTime =
        (maximumAttemptsCount - 1) * retryInterval.seconds
        + maximumAttemptsCount * operationDelay.seconds

      let expectedError = RetryError.noMoreAttempts(maximumAttemptsCount: maximumAttemptsCount)

      return check(
        operation: { attemptNumber, scheduler in
          Single
            .just(false)
            .delay(operationDelay.toRxTimeInterval, scheduler: scheduler)
        },
        retryInterval: retryInterval,
        maximumAttemptsCount: maximumAttemptsCount,
        expectedEvents: [.error(expectedFinalTime, expectedError)]
      )
    }
  }

  func testZeroMaximumAttemptsCount() {
    check(
      operation: { _, scheduler in
        Single
          .just(false)
          .delay(3.seconds, scheduler: scheduler)
      },
      retryInterval: 17.seconds,
      maximumAttemptsCount: 0,
      expectedEvents: [.error(0, RetryError.invalidMaximumAttemptsCount(maximumAttemptsCount: 0))]
    )
  }

  func testNegativeMaximumAttemptsCount() {
    check(
      operation: { _, scheduler in
        Single
          .just(false)
          .delay(3.seconds, scheduler: scheduler)
      },
      retryInterval: 17.seconds,
      maximumAttemptsCount: -1,
      expectedEvents: [.error(0, RetryError.invalidMaximumAttemptsCount(maximumAttemptsCount: -1))]
    )
  }

  @discardableResult
  private func check(operation: @escaping (Int, TestScheduler) -> Single<Bool>,
                     retryInterval: Duration,
                     maximumAttemptsCount: Int = Int.max,
                     expectedEvents: [Recorded<Event<Bool>>]) -> Bool {
    let scheduler = TestScheduler(initialClock: 0)

    var attemptNumber = 1

    let signal: Single<Bool> = Single.retry(
      until: { $0 },
      retryInterval: retryInterval,
      maximumAttemptsCount: maximumAttemptsCount,
      scheduler: scheduler,
      operation: {
        let result = operation(attemptNumber, scheduler)
        attemptNumber += 1
        return result
      }
    )

    let listener = scheduler.createObserver(Bool.self)

    let disposeBag = DisposeBag()

    disposeBag { signal ==> listener }

    scheduler.start()

    XCTAssertEqual(listener.events, expectedEvents)

    return listener.events == expectedEvents
  }
}
