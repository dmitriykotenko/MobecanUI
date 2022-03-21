import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class RxInputWithoutInitialValueTests: XCTestCase {
  
  func testThatInitiallyThereAreNoEvents() {
    
    let rxInput = RxInput<String>()
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let listener = scheduler.createObserver(String.self)
    let disposeBag = DisposeBag()

    disposeBag {
      rxInput ==> listener
    }
    
    scheduler.start()
    
    XCTAssertEqual(listener.events, [])
  }
  
  func testThatNothingIsReplayed() {
    
    let rxInput = RxInput<String>()
    
    rxInput.wrappedValue.onNext("two")
    rxInput.wrappedValue.onNext("three")
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let listener = scheduler.createObserver(String.self)
    let disposeBag = DisposeBag()

    disposeBag {
      rxInput ==> listener
    }
    
    scheduler.start()
    
    XCTAssertEqual(listener.events, [])
  }
  
  func testMultipleSubscriptions() {
    
    let rxInput = RxInput<String>()
    
    rxInput.wrappedValue.onNext("two")
    rxInput.wrappedValue.onNext("three")
    
    let scheduler = TestScheduler(initialClock: 0)
    let notifier = scheduler.createHotObservable([.next(10, "ten"), .next(20, "twenty")])
    
    let firstListener = scheduler.createObserver(String.self)
    let secondListener = scheduler.createObserver(String.self)
    let disposeBag = DisposeBag()

    disposeBag {
      notifier ==> rxInput.wrappedValue
      rxInput ==> firstListener
      rxInput ==> secondListener
    }
    
    scheduler.start()
    
    XCTAssertEqual(firstListener.events, [.next(10, "ten"), .next(20, "twenty")])
    XCTAssertEqual(secondListener.events, [.next(10, "ten"), .next(20, "twenty")])
  }

  static var allTests = [
    ("Test that initially there are no events", testThatInitiallyThereAreNoEvents),
    ("Test that nothing is replayed", testThatNothingIsReplayed),
    ("Test multiple subscriptions", testMultipleSubscriptions),
  ]
}
