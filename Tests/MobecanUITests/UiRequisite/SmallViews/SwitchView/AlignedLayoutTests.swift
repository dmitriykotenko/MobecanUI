import XCTest

import LayoutKit
import RxSwift
import RxTest

@testable import MobecanUI


class AlignedLayoutTests: XCTestCase {

  lazy var switchSize = uiSwitch().sizeThatFits(
    .init(
      width: veryLargeWidth,
      height: veryLargeHeight
    )
  )

  private let inaccuracy: CGFloat = 0.5
  private let font = UILabel().font!
  private let screenWidth: CGFloat = 320
  private let veryLargeWidth: CGFloat = 2000
  private let veryLargeHeight: CGFloat = 2000

  func testTopLayout() {
    check(
      layout: { .top($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: switchSize.width, height: 500),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: switchSize.width, height: 500),
      expectedChildFrame: .init(origin: .zero, size: switchSize)
    )
  }

  func testBottomLayout() {
    check(
      layout: { .bottom($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: switchSize.width, height: 500),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: switchSize.width, height: 500),
      expectedChildFrame: .init(x: 0, y: 500 - switchSize.height, width: switchSize.width, height: switchSize.height)
    )
  }

  func testLeadingLayout() {
    check(
      layout: { .leading($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: 320, height: switchSize.height),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: 320, height: switchSize.height),
      expectedChildFrame: .init(origin: .zero, size: switchSize)
    )
  }

  func testTrailingLayout() {
    check(
      layout: { .trailing($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: 320, height: switchSize.height),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: 320, height: switchSize.height),
      expectedChildFrame: .init(x: 320 - switchSize.width, y: 0, width: switchSize.width, height: switchSize.height)
    )
  }

  func testHorizontallyCenteredLayout() {
    check(
      layout: { .horizontallyCentered($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: 320, height: switchSize.height),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: 320, height: switchSize.height),
      expectedChildFrame: .init(
        x: 160 - 0.5 * switchSize.width,
        y: 0,
        width: switchSize.width,
        height: switchSize.height
      )
    )
  }

  func testVerticallyCenteredLayout() {
    check(
      layout: { .verticallyCentered($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: switchSize.width, height: 500),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: switchSize.width, height: 500),
      expectedChildFrame: .init(
        x: 0,
        y: 250 - 0.5 * switchSize.height,
        width: switchSize.width,
        height: switchSize.height
      )
    )
  }

  func testCenteredLayout() {
    check(
      layout: { .centered($0) },
      containerBounds: .init(x: 0, y: 0, width: 320, height: 500),
      expectedSize: .init(width: 320, height: 500),
      expectedChildSize: switchSize,
      expectedFrame: .init(x: 0, y: 0, width: 320, height: 500),
      expectedChildFrame: .init(
        x: 160 - 0.5 * switchSize.width,
        y: 250 - 0.5 * switchSize.height,
        width: switchSize.width,
        height: switchSize.height
      )
    )
  }

  private func check(layout: (UISwitch) -> AlignedLayout,
                     containerBounds: CGRect,
                     expectedSize: CGSize,
                     expectedChildSize: CGSize,
                     expectedFrame: CGRect,
                     expectedChildFrame: CGRect) {
    let layout = layout(uiSwitch())

    let containerSize = containerBounds.size

    let measurement = layout.measurement(within: containerSize)
    let size = measurement.size
    let desiredFrame = CGRect(origin: containerBounds.origin, size: size)
    let arrangement = measurement.arrangement(within: desiredFrame)

    XCTAssertEqual(expectedSize, measurement.size)
    XCTAssertEqual(expectedChildSize, measurement.sublayouts[0].size)
    XCTAssertEqual(expectedFrame, arrangement.frame)
    XCTAssertEqual(expectedChildFrame, arrangement.sublayouts[0].frame)
  }

  private func uiSwitch() -> UISwitch {
    let uiSwitch = UISwitch().fitToContent(axis: [.horizontal, .vertical])
    uiSwitch.setNeedsLayout()
    uiSwitch.layoutIfNeeded()
    return uiSwitch
  }

  private func assertEqual(_ actual: CGFloat,
                           _ expected: CGFloat) {
    XCTAssert(abs(actual - expected) < inaccuracy)
  }

  static var allTests = [
    ("Test AlignedLayout.top()", testTopLayout),
  ]
}
