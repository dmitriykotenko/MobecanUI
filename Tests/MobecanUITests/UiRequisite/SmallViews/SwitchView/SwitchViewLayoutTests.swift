import XCTest

import LayoutKit
import RxSwift
import RxTest

@testable import MobecanUI


class SwitchViewLayoutTests: XCTestCase {

  private let inaccuracy: CGFloat = 0.5
  private let font = UILabel().font!
  private let screenWidth: CGFloat = 320
  private let veryLargeHeight: CGFloat = 2000

  func testNilTitleLayout() {
    check(
      title: nil,
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: 50,
      expectedLabelCenterY: 25,
      expectedUiSwitchCenterY: 25
    )
  }

  func testEmptyTitleLayout() {
    check(
      title: "",
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: 50,
      expectedLabelCenterY: 25,
      expectedUiSwitchCenterY: 25
    )
  }

  func testSingleLineTitleLayout() {
    check(
      title: "Ghm",
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: 50,
      expectedLabelCenterY: 25,
      expectedUiSwitchCenterY: 25
    )
  }

  func testLargeTitleLayout() {
    let title = "Ghm\n\n\n\n\n\n\n\n\n\n\n\n\nGhm"

    let titleHeight = textHeight(title)

    check(
      title: title,
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: titleHeight,
      expectedLabelCenterY: titleHeight / 2,
      expectedUiSwitchCenterY: 50
    )
  }

  func testAutomaticCenteringOfUiSwitch() {
    let title = "Ghm\nGhm\nGhm\nGhm"
    let titleHeight = textHeight(title)

    check(
      title: title,
      minimumHeight: 50,
      maximumCenteredHeight: 300,
      expectedOverallHeight: titleHeight,
      expectedLabelCenterY: titleHeight / 2,
      expectedUiSwitchCenterY: titleHeight / 2
    )
  }

  func testHuggingOfSmallTitle() {
    checkHugging(
      title: "Ghm",
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: 50
    )
  }

  func testHuggingOfMediumTitle() {
    let title = "Ghm\nGhm\nGhm\nGhm\nGhm"
    let titleHeight = textHeight(title)

    checkHugging(
      title: "Ghm\nGhm\nGhm\nGhm\nGhm",
      minimumHeight: 50,
      maximumCenteredHeight: 500,
      expectedOverallHeight: titleHeight
    )
  }

  func testHuggingOfLargeTitle() {
    let title = "Ghm\nGhm\nGhm\nGhm\nGhm\nGhm\nGhm"
    let titleHeight = textHeight(title)

    checkHugging(
      title: title,
      minimumHeight: 50,
      maximumCenteredHeight: 100,
      expectedOverallHeight: titleHeight
    )
  }

  private func check(title: String?,
                     minimumHeight: CGFloat,
                     maximumCenteredHeight: CGFloat,
                     expectedOverallHeight: CGFloat,
                     expectedLabelCenterY: CGFloat,
                     expectedUiSwitchCenterY: CGFloat) {
    let label = UILabel().multilined().fitToContent(axis: [.vertical]).text(title)
    let uiSwitch = uiSwitch()

    let switchView = createSwitchView(
      label: label,
      uiSwitch: uiSwitch,
      maximumCenteredHeight: maximumCenteredHeight,
      minimumHeight: minimumHeight
    )

    let containerView = TestableContainerView(
      frame: .init(
        origin: .zero,
        size: .init(width: screenWidth, height: veryLargeHeight)
      )
    )

    containerView.addSubview(switchView)

    containerView.setNeedsLayout()
    containerView.layoutIfNeeded()

    assertEqual(switchView.frame.width, containerView.bounds.width)
    assertEqual(switchView.frame.height, expectedOverallHeight)
    assertEqual(label.frame.center.y, expectedLabelCenterY)
    assertEqual(uiSwitch.frame.center.y, expectedUiSwitchCenterY)
  }

  private func checkHugging(title: String?,
                            minimumHeight: CGFloat,
                            maximumCenteredHeight: CGFloat,
                            expectedOverallHeight: CGFloat) {
    let switchView = createSwitchView(
      label: UILabel().multilined().fitToContent(axis: [.vertical]).text(title),
      uiSwitch: uiSwitch(),
      maximumCenteredHeight: maximumCenteredHeight,
      minimumHeight: minimumHeight
    )

    switchView.setNeedsLayout()
    switchView.layoutIfNeeded()

    let containerView = TestableContainerView(
      frame: .init(
        origin: .zero,
        size: .init(width: screenWidth, height: veryLargeHeight)
      )
    )

    containerView.addSubview(switchView)

    containerView.setNeedsLayout()
    containerView.layoutIfNeeded()

    assertEqual(switchView.frame.height, expectedOverallHeight)
  }

  private func uiSwitch() -> UISwitch {
    UISwitch().fitToContent(axis: [.horizontal, .vertical])
  }

  private func createSwitchView(label: UILabel,
                                uiSwitch: UISwitch,
                                maximumCenteredHeight: CGFloat,
                                minimumHeight: CGFloat) -> SwitchView {
    SwitchView(
      label: label,
      uiSwitch: uiSwitch,
      layout: .init(
        minimumHeight: minimumHeight,
        spacing: 10,
        switchPlacement: .centerOrTop(maximumCenteredHeight: maximumCenteredHeight)
      )
    )
  }

  private func textHeight(_ title: String) -> CGFloat {
    title.unroundedHeight(forWidth: screenWidth, font: font)
  }

  private func assertEqual(_ actual: CGFloat,
                           _ expected: CGFloat) {
    XCTAssert(abs(actual - expected) < inaccuracy)
  }

  static var allTests = [
    ("Test SwitchView layout for nil title", testNilTitleLayout),
    ("Test SwitchView layout for empty string title", testEmptyTitleLayout),
    ("Test SwitchView layout for single-line title", testSingleLineTitleLayout),
    ("Test SwitchView layout for large multi-line title", testLargeTitleLayout),
    ("Test automatic centering of UISwitch", testAutomaticCenteringOfUiSwitch),
    ("Test that SwitchView hugs its content when title is small", testHuggingOfSmallTitle),
    ("Test that SwitchView hugs its content when title has medium size", testHuggingOfMediumTitle),
    ("Test that SwitchView hugs its content when title is large", testHuggingOfLargeTitle),
  ]
}


private class TestableContainerView: UIView {

  override func layoutSubviews() {
    subviews.forEach {
      $0.frame = .init(origin: .zero, size: $0.sizeThatFits(self.bounds.size))
    }
  }
}
