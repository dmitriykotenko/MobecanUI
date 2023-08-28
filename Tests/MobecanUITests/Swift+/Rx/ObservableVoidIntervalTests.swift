// Copyright © 2023 Mobecan. All rights reserved.

import XCTest
@testable import MobecanUI

import RxSwift
import RxTest


final class ObservableVoidIntervalTests: XCTestCase {

  func test() {
    let scheduler = TestScheduler(initialClock: 0)
    let signal: Observable<Void> = Observable.voidInterval(33.seconds, scheduler: scheduler).take(4)
    let listener = scheduler.createObserver(EquatableVoid.self)

    let disposeBag = DisposeBag()

    disposeBag { signal.map { EquatableVoid.instance } ==> listener }

    scheduler.start()

    XCTAssertEqual(
      listener.events,
      [
        .next(0, .instance),
        .next(33, .instance),
        .next(66, .instance),
        .next(99, .instance),
        .completed(99)
      ]
    )
  }
}
