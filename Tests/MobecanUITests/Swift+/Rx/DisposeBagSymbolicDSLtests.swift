// Copyright © 2021 Mobecan. All rights reserved.

import XCTest
@testable import MobecanUI

import RxSwift
import RxTest


final class DisposeBagSymbolicDSLtests: XCTestCase {

  func testRightArrow() {
    let scheduler = TestScheduler(initialClock: 0)
    let signal: TestableObservable<Int> = scheduler.createHotObservable([.next(1000, 42)])
    let listener: BehaviorSubject<Int?> = .init(value: 17)

    let disposeBag = DisposeBag()

    disposeBag { signal ==> listener }

    scheduler.start()

    XCTAssertEqual( try listener.value(), 42)
  }

  func testLeftArrow() {
    let scheduler = TestScheduler(initialClock: 0)
    let signal: TestableObservable<Int> = scheduler.createHotObservable([.next(1000, 42)])
    let listener: BehaviorSubject<Int?> = .init(value: 17)

    let disposeBag = DisposeBag()

    disposeBag { listener <== signal }

    scheduler.start()

    XCTAssertEqual( try listener.value(), 42)
  }

  func testRightArrowWithScheduler() {
    let scheduler = TestScheduler(initialClock: 0)
    let listener: BehaviorSubject<Int?> = .init(value: 17)

    let disposeBag = DisposeBag()

    disposeBag(scheduler) { Observable.just(42) ==> listener }

    XCTAssertEqual( try listener.value(), 17)

    scheduler.start()

    XCTAssertEqual( try listener.value(), 42)
  }
}
