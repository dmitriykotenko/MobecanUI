import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class PseudoButtonTests: XCTestCase {

  func testThatInitiallyValueIsNil() {
    check(
      pseudoButton: .init(label: UILabel(), format: { $0 }),
      inputValues: [],
      expectedOutputValues: [.next(0, nil)]
    )
  }

  func testThatValueGetterIsProperlyUpdated() {
    check(
      pseudoButton: .init(label: UILabel(), format: { $0 }),
      inputValues: [.next(10, "1"), .next(20, "2")],
      expectedOutputValues: [.next(0, nil), .next(10, "1"), .next(20, "2")]
    )
  }

  func testThatLabelTextIsProperlyUpdated() {
    let label = UILabel()
    let pseudoButton = PseudoButton<String>(label: label, format: { $0 ?? "defaultString" })

    XCTAssertEqual(label.text, "defaultString")

    pseudoButton.value.onNext("Go!")

    XCTAssertEqual(label.text, "Go!")
  }

  func testThatNestedButtonTitleIsProperlyUpdated() {
    let nestedButton = UIButton()
    let pseudoButton = PseudoButton<ButtonForeground>(button: nestedButton, format: { $0 ?? .empty })

    XCTAssertEqual(nestedButton.title(for: .normal), nil)

    pseudoButton.value.onNext(.title("Go!"))
    XCTAssertEqual(nestedButton.title(for: .normal), "Go!")

    pseudoButton.value.onNext(.image(UIImage()))
    XCTAssertEqual(nestedButton.title(for: .normal), nil)

    pseudoButton.value.onNext(nil)
    XCTAssertEqual(nestedButton.title(for: .normal), nil)

    pseudoButton.value.onNext(.title("Steady?"))
    XCTAssertEqual(nestedButton.title(for: .normal), "Steady?")
  }

  private func check<Value: Equatable>(pseudoButton: PseudoButton<Value>,
                                       inputValues: [Recorded<Event<Value?>>],
                                       expectedOutputValues: [Recorded<Event<Value?>>]) {
    let scheduler = TestScheduler(initialClock: 0)

    let inputObservable = scheduler.createHotObservable(inputValues)
    let listener = scheduler.createObserver(Value?.self)
    let disposeBag = DisposeBag()

    disposeBag {
      inputObservable ==> pseudoButton.value
      pseudoButton.valueGetter ==> listener
    }

    scheduler.start()

    XCTAssertEqual(
      listener.events,
      expectedOutputValues
    )
  }

  static var allTests = [
    ("Test that initially value is nil", testThatInitiallyValueIsNil),
    ("Test that .valueGetter is properly updated", testThatValueGetterIsProperlyUpdated),
    ("Test that label's text is properly updated", testThatLabelTextIsProperlyUpdated),
    ("Test that nested button's title is properly updated", testThatNestedButtonTitleIsProperlyUpdated),
  ]
}
