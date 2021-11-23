import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class ZstackFlexibilityTests: XCTestCase {

  func testHorizontalFlexibility1() {
    check(
      childrenPriorities: [
        (horizontal: .required, vertical: .defaultHigh),
        (horizontal: .defaultLow, vertical: .defaultHigh),
      ],
      expectedParentPriority: (
        horizontal: .required,
        vertical: .defaultHigh
      )
    )
  }

  func testHorizontalFlexibility2() {
    check(
      childrenPriorities: [
        (horizontal: .defaultLow, vertical: .required),
        (horizontal: .defaultHigh, vertical: .required),
      ],
      expectedParentPriority: (
        horizontal: .defaultHigh,
        vertical: .required
      )
    )
  }

  func testVerticalFlexibility1() {
    check(
      childrenPriorities: [
        (horizontal: .defaultHigh, vertical: .required),
        (horizontal: .defaultHigh, vertical: .init(0)),
      ],
      expectedParentPriority: (
        horizontal: .defaultHigh,
        vertical: .required
      )
    )
  }

  func testVerticalFlexibility2() {
    check(
      childrenPriorities: [
        (horizontal: .defaultHigh, vertical: .init(0)),
        (horizontal: .defaultHigh, vertical: .defaultLow)
      ],
      expectedParentPriority: (
        horizontal: .defaultHigh,
        vertical: .defaultLow
      )
    )
  }

  private func check(childrenPriorities: [(horizontal: UILayoutPriority, vertical: UILayoutPriority)],
                     expectedParentPriority: (horizontal: UILayoutPriority, vertical: UILayoutPriority)) {
    let zStack = UIView.zstack(
      subviews(contentHuggingPriorities: childrenPriorities)
    )

    XCTAssertEqual(
      zStack.contentHuggingPriority(for: .horizontal),
      expectedParentPriority.horizontal
    )

    XCTAssertEqual(
      zStack.contentHuggingPriority(for: .vertical),
      expectedParentPriority.vertical
    )
  }

  func subviews(contentHuggingPriorities: [(horizontal: UILayoutPriority, vertical: UILayoutPriority)]) -> [UIView] {
    contentHuggingPriorities.map {
      UIView()
        .translatesAutoresizingMaskIntoConstraints(false)
        .contentHuggingPriority($0, axis: [.horizontal])
        .contentHuggingPriority($1, axis: [.vertical])
    }
  }

  static var allTests = [
    ("Test horizontal flexibility - 1", testHorizontalFlexibility1),
    ("Test horizontal flexibility - 2", testHorizontalFlexibility2),
    ("Test vertical flexibility - 1", testVerticalFlexibility1),
    ("Test vertical flexibility - 2", testVerticalFlexibility2),
  ]
}
