import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class RxInputWithInitialValueTests: XCTestCase {
  
  func testThatLastValueIsReplayedOnSubscription() {
    
    let rxInput = RxInput("one")
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let listener = scheduler.createObserver(String.self)
    let disposeBag = DisposeBag()

    disposeBag {
      rxInput ==> listener
    }
    
    scheduler.start()
    
    XCTAssertEqual(listener.events, [.next(0, "one")])
  }
  
  func testThatOnlyLastValueIsReplayed() {
    
    let rxInput = RxInput("one")
    
    rxInput.wrappedValue.onNext("two")
    rxInput.wrappedValue.onNext("three")
    
    let scheduler = TestScheduler(initialClock: 0)
    
    let listener = scheduler.createObserver(String.self)
    let disposeBag = DisposeBag()

    disposeBag {
      rxInput ==> listener
    }
    
    scheduler.start()
    
    XCTAssertEqual(listener.events, [.next(0, "three")])
  }
  
  func testMultipleSubscriptions() {
    
    let rxInput = RxInput("one")
    
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
    
    XCTAssertEqual(firstListener.events, [.next(0, "three"), .next(10, "ten"), .next(20, "twenty")])
    XCTAssertEqual(secondListener.events, [.next(0, "three"), .next(10, "ten"), .next(20, "twenty")])
  }

  static var allTests = [
    ("Test that last value is replayed on subscription", testThatLastValueIsReplayedOnSubscription),
    ("Test only last value is replayed", testThatOnlyLastValueIsReplayed),
    ("Test multiple subscriptions", testMultipleSubscriptions),
  ]
}
