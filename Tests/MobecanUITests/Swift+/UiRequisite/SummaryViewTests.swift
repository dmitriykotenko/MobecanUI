import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class SummaryViewTests: XCTestCase {

  let imageSize = CGSize(width: 7, height: 7)
  
  let labels = ThreeLinesLabelsGrid(
    topLabel: UILabel().text("Death is only the beginning."),
    topRightLabel: UILabel().text("TR"),
    middleLabel: UILabel().text("M"),
    bottomLabel: UILabel().text("B"),
    spacing: .zero
  )

  func testTopImagePlacement() {
    check(
      imageView: UIImageView().autolayoutSize(imageSize),
      placement: .top(5),
      expectedImageViewFrame: .init(origin: .init(x: 0, y: 5), size: imageSize)
    )
  }
  
  func testBottomImagePlacement() {
    check(
      imageView: UIImageView().autolayoutSize(imageSize),
      labels: labels,
      placement: .bottom(5),
      summaryViewSize: .init(width: 320, height: imageSize.height + 9),
      expectedImageViewFrame: .init(origin: .init(x: 0, y: 4), size: imageSize)
    )
  }
  
  func testCenterImagePlacement() {
    check(
      imageView: UIImageView().autolayoutSize(imageSize),
      labels: labels,
      placement: .center,
      summaryViewSize: .init(width: 320, height: imageSize.height + 50),
      expectedImageViewFrame: .init(origin: .init(x: 0, y: 25), size: imageSize)
    )
  }
  
  func testFirstBaselineImagePlacement() {
    let imageView = UIImageView().autolayoutSize(imageSize)
    
    let summaryView =
      SummaryView<Int, ThreeLinesLabelsGrid>(
        iconContainer: .simple(
          imageView: imageView,
          placeholder: nil,
          placement: .firstBaseline(10)
        ),
        labels: labels,
        backgroundView: UIView(),
        spacing: 0,
        insets: .zero
      )
      .autolayoutSize(.init(width: 500, height: imageSize.height + 50))
    
    summaryView.layoutIfNeeded()
    
    let actualImageY = summaryView.convert(imageView.frame.origin, from: imageView.superview).y
    let expectedImageY = labels.topLabel.font.ascender - imageSize.height + 10
    
    XCTAssert(
      abs(actualImageY - expectedImageY) < 0.5,
      "Actual and expected image Y are too different:\n" +
      "Actual image Y = \(actualImageY)\n" +
      "Expected image Y = \(expectedImageY)"
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
        backgroundView: UIView(),
        spacing: spacing,
        insets: insets
      )
      .autolayoutSize(summaryViewSize)
    
    summaryView.layoutIfNeeded()
    
    XCTAssertEqual(
      summaryView.convert(imageView.frame, from: imageView.superview),
      expectedImageViewFrame
    )
  }

  static var allTests = [
    ("Test top image placement", testTopImagePlacement),
    ("Test bottom image placement", testBottomImagePlacement),
    ("Test center image placement", testCenterImagePlacement),
    ("Test first baseline image placement", testFirstBaselineImagePlacement)
  ]
}
