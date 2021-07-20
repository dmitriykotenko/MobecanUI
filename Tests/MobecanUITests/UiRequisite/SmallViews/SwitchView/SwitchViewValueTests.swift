import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class SwitchViewValueTests: XCTestCase {

  func testThatInitialIsOnAffectsCurrentIsOn() {
    let switchView = SwitchView(
      label: UILabel(),
      uiSwitch: UISwitch()
    )

    let scheduler = TestScheduler(initialClock: 0)
    let initialIsOn = scheduler.createHotObservable([.next(10, true)])
    let isOn = scheduler.createObserver(Bool.self)
    let disposeBag = DisposeBag()

    initialIsOn.bind(to: switchView.initialIsOn).disposed(by: disposeBag)
    switchView.isOn.bind(to: isOn).disposed(by: disposeBag)

    scheduler.start()

    XCTAssertEqual(
      isOn.events,
      [.next(0, false), .next(10, true)]
    )
  }

  static var allTests = [
    ("Test that initial isOn affects current isOn", testThatInitialIsOnAffectsCurrentIsOn),
  ]
}
