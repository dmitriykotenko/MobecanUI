import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class StackViewChildrenAlignmentTests: XCTestCase {

  func testTopAlignment() {
    check(
      verticalAlignment: .top,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 0, width: 10, height: 10)
    )
  }

  func testBottomAlignment() {
    check(
      verticalAlignment: .bottom,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 990, width: 10, height: 10)
    )
  }

  func testVerticalCenterAlignment() {
    check(
      verticalAlignment: .center,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 495, width: 10, height: 10)
    )
  }

  func testVerticalFillAlignment() {
    check(
      verticalAlignment: .fill,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 0, width: 10, height: 1000)
    )
  }

  func testLeadingAlignment() {
    check(
      horizontalAlignment: .leading,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 0, width: 10, height: 10)
    )
  }

  func testTrailingAlignment() {
    check(
      horizontalAlignment: .trailing,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 310, y: 0, width: 10, height: 10)
    )
  }

  func testHorizontalCenterAlignment() {
    check(
      horizontalAlignment: .center,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 155, y: 0, width: 10, height: 10)
    )
  }

  func testHorizontalFillAlignment() {
    check(
      horizontalAlignment: .fill,
      imageViewSize: .square(size: 10),
      parentViewSize: .init(width: 320, height: 1000),
      expectedImageViewFrame: .init(x: 0, y: 0, width: 320, height: 10)
    )
  }

  private func check(verticalAlignment: UIStackView.Alignment,
                     imageViewSize: CGSize,
                     parentViewSize: CGSize,
                     expectedImageViewFrame: CGRect) {
    check(
      stackAxis: .horizontal,
      alignment: verticalAlignment,
      imageViewSize: imageViewSize,
      parentViewSize: parentViewSize,
      expectedImageViewFrame: expectedImageViewFrame
    )
  }

  private func check(horizontalAlignment: UIStackView.Alignment,
                     imageViewSize: CGSize,
                     parentViewSize: CGSize,
                     expectedImageViewFrame: CGRect) {
    check(
      stackAxis: .vertical,
      alignment: horizontalAlignment,
      imageViewSize: imageViewSize,
      parentViewSize: parentViewSize,
      expectedImageViewFrame: expectedImageViewFrame
    )
  }

  private func check(stackAxis: NSLayoutConstraint.Axis,
                     alignment: UIStackView.Alignment,
                     imageViewSize: CGSize,
                     parentViewSize: CGSize,
                     expectedImageViewFrame: CGRect) {
    let imageView = UIImageView.sizable(size: imageViewSize)

    let label = DiverseLabel().multilined().text(
      "I think that the loveliest time of the year is Spring. And you? Don't you do? 'Cause you do!"
    )

    let stackView = stackView(
      axis: stackAxis,
      alignment: alignment,
      subviews: [imageView, label]
    )

    let stackViewContainer = UIView.vstack([stackView])
    stackViewContainer.frame = .init(origin: .zero, size: parentViewSize)

    stackViewContainer.layoutIfNeeded()

    XCTAssertEqual(imageView.frame, expectedImageViewFrame)
  }

  private func stackView(axis: NSLayoutConstraint.Axis,
                         alignment: UIStackView.Alignment,
                         subviews: [UIView]) -> UIView {
    switch axis {
    case .horizontal:
      return .hstack(alignment: alignment, subviews)
    case .vertical:
      return .vstack(alignment: alignment, subviews)
    }
  }
}


private extension UIImageView {

  static func sizable(size: CGSize) -> SizableImageView {
    SizableImageView()
      .fixSize(size)
      .contentMode(.scaleAspectFill)
  }
}
