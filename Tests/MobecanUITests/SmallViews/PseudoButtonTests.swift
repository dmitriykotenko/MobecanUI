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
    let pseudoButton = PseudoButton(label: label, format: { $0 })

    XCTAssertEqual(label.text, nil)

    pseudoButton.value.onNext("Go!")

    XCTAssertEqual(label.text, "Go!")
  }

  func testThatNestedButtonTitleIsProperlyUpdated() {
    let nestedButton = UIButton()
    let pseudoButton = PseudoButton<ButtonForeground>(button: nestedButton, format: { $0 })

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

    inputObservable.bind(to: pseudoButton.value).disposed(by: disposeBag)
    pseudoButton.valueGetter.drive(listener).disposed(by: disposeBag)

    scheduler.start()

    XCTAssertEqual(
      listener.events,
      expectedOutputValues
    )
  }
}
