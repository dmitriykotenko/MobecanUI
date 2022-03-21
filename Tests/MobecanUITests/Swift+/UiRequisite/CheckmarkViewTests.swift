import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class CheckmarkViewTests: XCTestCase {

  func testInitiallySelectedCheckmark() {
    check(
      initialValue: true,
      expectedIsSelected: [.next(0, true)],
      errorMessage: "Checkmark must be selected initially."
    )
  }

  func testInitiallyNotSelectedCheckmark() {
    check(
      initialValue: false,
      expectedIsSelected: [.next(0, false)],
      errorMessage: "Checkmark must be deselected initially."
    )
  }

  func testIsSelectedProperty() {
    _ = (1...1000).drop { _ in
      let initialValue = Bool.random()
      let selections = randomSelections()

      return check(
        initialValue: initialValue,
        setIsSelected: selections,
        expectedIsSelected: [.next(0, initialValue)] + selections,
        errorMessage: ".isSelected signal is wrong"
      )
    }
    .first
  }

  @discardableResult
  private func check(initialValue: Bool,
                     setIsSelected: [Recorded<Event<Bool>>] = [],
                     expectedIsSelected: [Recorded<Event<Bool>>],
                     errorMessage: String) -> Bool {

    let checkmarkView = CheckmarkView(
      selectedView: UIView(),
      notSelectedView: UIView(),
      isSelected: initialValue,
      horizontalInset: 0
    )

    let testScheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    let actualIsSelected = testScheduler.createObserver(Bool.self)

    disposeBag {
      testScheduler.createHotObservable(setIsSelected) ==>
        checkmarkView.setIsSelected

      checkmarkView.isSelected ==> actualIsSelected
    }

    testScheduler.start()

    if actualIsSelected.events != expectedIsSelected {
      XCTFail(
        errorMessage + "\n" +
          "Actual .isSelected: \(actualIsSelected.events)\n" +
        "Expected .isSelected: \(expectedIsSelected)"
      )
      return false
    } else {
      return true
    }
  }

  private func randomSelections() -> [Recorded<Event<Bool>>] {
    let numberOfEvents = Int.random(in: 0...10)

    return (0..<numberOfEvents)
      .map { _ in .next(Int.random(in: 0...1000), Bool.random()) }
      .sorted { $0.time < $1.time }
  }

  static var allTests = [
    ("Test initially selected checkmark", testInitiallySelectedCheckmark),
    ("Test initially not selected checkmark", testInitiallyNotSelectedCheckmark),
    ("Test .isSelected property", testIsSelectedProperty)
  ]
}
