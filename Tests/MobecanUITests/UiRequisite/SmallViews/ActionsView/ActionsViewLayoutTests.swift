import XCTest

import LayoutKit
import RxSwift
//import RxTest

@testable import MobecanUI


class ActionsViewLayoutTests: ActionsViewLayoutTester {

  func testSmallContentLayout() {
    let test = Test(
      contentViewText: "Spring",
      errorLabelInsets: .zero,
      errorText: nil,
      deleteButtonHeight: 1 // 'Delete' button height must be less than checkmarkView's height.
    )

    let maximumContentViewWidth = test.screenWidth - test.checkmarkSize.width

    let expectedContentViewHeight = test.contentViewText.unroundedHeight(
      forWidth: maximumContentViewWidth,
      font: test.contentView.font
    )

    assert(
      test: test,
      subview: \.actionsView,
      expectedWidth: test.screenWidth,
      expectedHeight: test.checkmarkSize.height
    )

    assert(
      test: test,
      subview: \.checkmarkView,
      expectedAbsoluteMinX: 0,
      expectedAbsoluteMinY: 0,
      expectedSize: test.checkmarkSize
    )

    assert(
      test: test,
      subview: \.contentView,
      expectedAbsoluteMinX: test.checkmarkSize.width,
      expectedMaximumWidth: maximumContentViewWidth,
      expectedHeight: expectedContentViewHeight
    )

    XCTAssertEqual(test.errorLabel.isVisible, false)
  }

  func testLargeContentLayoutWithoutError() {
    let test = Test(
      contentViewText: .init(repeating: "The loveliest time of the year is Spring", count: 10),
      errorLabelInsets: .zero,
      errorText: nil
    )

    let maximumContentViewWidth = test.screenWidth - test.checkmarkSize.width

    let expectedTotalHeight = test.contentViewText.unroundedHeight(
      forWidth: maximumContentViewWidth,
      font: test.contentView.font
    )

    assert(
      test: test,
      subview: \.actionsView,
      expectedWidth: test.screenWidth,
      expectedHeight: expectedTotalHeight
    )

    assert(
      test: test,
      subview: \.checkmarkView,
      expectedAbsoluteMinX: 0,
      expectedAbsoluteMinY: 0,
      expectedSize: test.checkmarkSize
    )

    assert(
      test: test,
      subview: \.contentView,
      expectedAbsoluteMinX: test.checkmarkSize.width,
      expectedMaximumWidth: maximumContentViewWidth,
      expectedHeight: expectedTotalHeight
    )

    XCTAssertEqual(test.errorLabel.isVisible, false)
  }

  func testLargeContentLayoutWithError() {
    let test = Test(
      contentViewText: .init(repeating: "The loveliest time of the year is Spring", count: 10),
      errorLabelInsets: .zero,
      errorText: "Error happened"
    )

    let maximumContentViewWidth = test.screenWidth - test.checkmarkSize.width

    let expectedContentViewHeight = test.contentViewText.unroundedHeight(
      forWidth: maximumContentViewWidth,
      font: test.contentView.font
    )

    let expectedErrorLabelHeight = test.errorText!.unroundedHeight(
      forWidth: test.screenWidth,
      font: test.errorLabel.font
    )

    let expectedTotalHeight = expectedContentViewHeight + expectedErrorLabelHeight

    assert(
      test: test,
      subview: \.actionsView,
      expectedWidth: test.screenWidth,
      expectedHeight: expectedTotalHeight
    )

    assert(
      test: test,
      subview: \.contentView,
      expectedAbsoluteMinX: test.checkmarkSize.width,
      expectedMaximumWidth: maximumContentViewWidth,
      expectedHeight: expectedContentViewHeight
    )
  }

  func testTrailingCheckmarkPlacement() {
    let test = Test(
      contentViewText: .init(repeating: "The loveliest time of the year is Spring", count: 10),
      checkmarkPlacement: .trailing,
      errorLabelInsets: .zero,
      errorText: "Error happened"
    )

    let maximumContentViewWidth = test.screenWidth - test.checkmarkSize.width

    let expectedContentViewHeight = test.contentViewText.unroundedHeight(
      forWidth: maximumContentViewWidth,
      font: test.contentView.font
    )

    let expectedErrorLabelHeight = test.errorText!.unroundedHeight(
      forWidth: test.screenWidth,
      font: test.errorLabel.font
    )

    let expectedTotalHeight = expectedContentViewHeight + expectedErrorLabelHeight

    assert(
      test: test,
      subview: \.actionsView,
      expectedWidth: test.screenWidth,
      expectedHeight: expectedTotalHeight
    )

    assert(
      test: test,
      subview: \.checkmarkView,
      expectedAbsoluteMinY: 0,
      expectedAbsoluteMaxX: test.screenWidth,
      expectedSize: test.checkmarkSize
    )

    assert(
      test: test,
      subview: \.contentView,
      expectedAbsoluteMinX: 0,
      expectedAbsoluteMinY: 0,
      expectedMaximumWidth: maximumContentViewWidth,
      expectedHeight: expectedContentViewHeight
    )
  }

  func testErrorLabelPlacement() {
    let test = Test(
      contentViewText: .init(repeating: "The loveliest time of the year is Spring", count: 10),
      errorLabelInsets: .init(top: 2, left: 5, bottom: 13, right: 19),
      errorText: "Error happened"
    )

    let maximumContentViewWidth = test.screenWidth - test.checkmarkSize.width

    let expectedContentViewHeight = test.contentViewText.unroundedHeight(
      forWidth: maximumContentViewWidth,
      font: test.contentView.font
    )

    let expectedErrorLabelWidth =
      test.screenWidth - test.errorLabelInsets.left - test.errorLabelInsets.right

    let expectedErrorLabelHeight = test.errorText!.unroundedHeight(
      forWidth: expectedErrorLabelWidth,
      font: test.errorLabel.font
    )

    let expectedTotalHeight =
      expectedContentViewHeight +
      expectedErrorLabelHeight +
      test.errorLabelInsets.top +
      test.errorLabelInsets.bottom

    assert(
      test: test,
      subview: \.actionsView,
      expectedWidth: test.screenWidth,
      expectedHeight: expectedTotalHeight
    )

    assert(
      test: test,
      subview: \.checkmarkView,
      expectedAbsoluteMinX: 0,
      expectedAbsoluteMinY: 0,
      expectedSize: test.checkmarkSize
    )

    assert(
      test: test,
      subview: \.contentView,
      expectedMaximumWidth: maximumContentViewWidth,
      expectedHeight: expectedContentViewHeight
    )

    XCTAssertEqual(test.errorLabel.isVisible, true)

    assert(
      test: test,
      subview: \.errorLabel,
      expectedAbsoluteMinX: test.errorLabelInsets.left,
      expectedAbsoluteMaxY: expectedTotalHeight - test.errorLabelInsets.bottom,
      expectedMaximumWidth: expectedErrorLabelWidth,
      expectedHeight: expectedErrorLabelHeight
    )
  }
}
