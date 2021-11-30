import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class SummaryViewTests: XCTestCase {

  let smallImageSize = CGSize(width: 7, height: 7)
  let largeImageSize = CGSize(width: 7, height: 1007)

  lazy var labels = ThreeLinesLabelsGrid(
    subviews: .init(
      topLabel: label().text("Death is only the beginning."),
      topRightLabel: label().text("TR"),
      middleLabel: label().text("M"),
      bottomLabel: label().text("B")
    ),
    spacing: .zero,
    topRightLabelInsets: .zero
  )

  lazy var textsHeight = label().font.lineHeight * 3

  private func label() -> UILabel {
    let label = UILabel()
    label.font = .systemFont(ofSize: 8)
    return label
  }

  func testTopPlacementOfSmallImage() {
    check(
      imageView: SizableImageView().fixSize(smallImageSize),
      placement: .top(5),
      expectedImageViewFrame: .init(
        origin: .init(x: 0, y: 5),
        size: smallImageSize
      )
    )
  }

  func testTopPlacementOfLargeImage() {
    check(
      imageView: SizableImageView().fixSize(largeImageSize),
      placement: .top(5),
      expectedImageViewFrame: .init(
        origin: .init(x: 0, y: 5),
        size: largeImageSize
      )
    )
  }

  func testBottomPlacementOfSmallImage() {
    let textsHeight = label().font.lineHeight * 3.0

    check(
      imageView: SizableImageView().fixSize(smallImageSize),
      labels: labels,
      placement: .bottom(5),
      summaryViewSize: .init(width: 320, height: textsHeight),
      expectedImageViewFrame: .init(
        origin: .init(
          x: 0,
          y: textsHeight - smallImageSize.height - 5
        ),
        size: smallImageSize
      )
    )
  }

  func testBottomPlacementOfLargeImage() {
    check(
      imageView: SizableImageView().fixSize(largeImageSize),
      labels: labels,
      placement: .bottom(5),
      summaryViewSize: .init(width: 320, height: largeImageSize.height + 5),
      expectedImageViewFrame: .init(
        origin: .init(x: 0, y: 0),
        size: largeImageSize
      )
    )
  }

  func testCenterPlacementOfSmallImage() {
    check(
      imageView: SizableImageView().fixSize(smallImageSize),
      labels: labels,
      placement: .center,
      summaryViewSize: .init(width: 320, height: textsHeight),
      expectedImageViewFrame: .init(
        origin: .init(x: 0, y: (textsHeight - smallImageSize.height) / 2.0),
        size: smallImageSize
      )
    )
  }

  func testCenterPlacementOfLargeImage() {
    check(
      imageView: SizableImageView().fixSize(largeImageSize),
      labels: labels,
      placement: .center,
      summaryViewSize: .init(width: 320, height: largeImageSize.height),
      expectedImageViewFrame: .init(
        origin: .init(x: 0, y: 0),
        size: largeImageSize
      )
    )
  }

  private func check(imageView: UIImageView,
                     labels: ThreeLinesLabelsGrid = .empty,
                     placement: SimpleImageViewContainer.VerticalPlacement,
                     spacing: CGFloat = 0,
                     insets: UIEdgeInsets = .zero,
                     summaryViewSize: CGSize = .init(width: 320, height: 90),
                     expectedImageViewFrame: CGRect) {
    let summaryView =
      SummaryView<Int, ThreeLinesLabelsGrid>(
        iconContainer: .simple(
          imageView: imageView,
          placeholder: nil,
          placement: placement
        ),
        labels: labels,
        backgroundView: .spacer(),
        spacing: spacing,
        insets: insets
      )

    let containerView = TestableContainerView(size: summaryViewSize)

    containerView.addSubview(summaryView)

    containerView.setNeedsLayout()
    containerView.layoutIfNeeded()

    assertRectsAreEqual(
      actual: summaryView.convert(imageView.frame, from: imageView.superview),
      expected: expectedImageViewFrame
    )
  }

  private func assertRectsAreEqual(actual: CGRect,
                                   expected: CGRect) {
    let maximum = max(
      abs(actual.minX - expected.minX),
      abs(actual.minY - expected.minY),
      abs(actual.maxX - expected.maxX),
      abs(actual.maxY - expected.maxY)
    )

    let inaccuracy: CGFloat = 0.5

    if maximum >= inaccuracy {
      XCTFail("Actual rect \(actual) is too different from expected rect \(expected)")
    }
  }

  class TestableContainerView: UIView {

    init(size: CGSize) {
      super.init(frame: .init(origin: .zero, size: size))
    }

    required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

    override func layoutSubviews() {
      subviews.forEach {
        $0.frame = .init(origin: .zero, size: $0.sizeThatFits(self.bounds.size))
        $0.layoutSubviews()
      }
    }
  }

  static var allTests = [
    ("Test top placement of small image", testTopPlacementOfSmallImage),
    ("Test top placement of large image", testTopPlacementOfLargeImage),
    ("Test bottom placement of small image", testBottomPlacementOfSmallImage),
    ("Test bottom placement of large image", testBottomPlacementOfLargeImage),
    ("Test center placement of small image", testCenterPlacementOfSmallImage),
    ("Test center placement of large image", testCenterPlacementOfLargeImage),
  ]
}
