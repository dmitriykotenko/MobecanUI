import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class DiverseButtonNativeSizePolicyTests: XCTestCase {

  func testDefaultPolicyForLargeImage() {
    check(
      nativeSizePolicy: .superSizeThatFits,
      image: .singleColorImage(.black, size: .square(size: 100)),
      font: .systemFont(ofSize: 5),
      title: "Normal",
      expectedDesiredHeight: 100
    )
  }

  func testDefaultPolicyForLargeFont() {
    let font = UIFont.systemFont(ofSize: 50)

    check(
      nativeSizePolicy: .superSizeThatFits,
      image: .singleColorImage(.black, size: .square(size: 10)),
      font: font,
      title: "x",
      expectedDesiredHeight: font.lineHeight
    )
  }

  func testTitleBasedPolicyForSinglelinedTitle() {
    let font = UIFont.systemFont(ofSize: 50)

    check(
      nativeSizePolicy: .titleLabelBased,
      image: nil,
      font: font,
      title: "x",
      expectedDesiredHeight: font.lineHeight
    )
  }

  func testTitleBasedPolicyForLongSinglelinedTitle() {
    let oneThirdOfTitle = "a b c d e f g h"
    let font = UIFont.systemFont(ofSize: 50)
    
    let label = DiverseLabel()
    label.font = font
    label.text = oneThirdOfTitle

    // Вычисляем ширину, при которой заголовок кнопки должен занять ровно три строки.
    let width = label.sizeThatFits(.square(size: CGFloat.greatestFiniteMagnitude)).width

    check(
      nativeSizePolicy: .titleLabelBased,
      width: width,
      image: nil,
      font: font,
      title: oneThirdOfTitle + " " + oneThirdOfTitle + " " + oneThirdOfTitle,
      expectedDesiredHeight: font.lineHeight * 3
    )
  }

  func testTitleBasedPolicyForMultilinedTitle() {
    let font = UIFont.systemFont(ofSize: 50)

    check(
      nativeSizePolicy: .titleLabelBased,
      image: nil,
      font: font,
      title: """
      x
      y
      z
      """,
      expectedDesiredHeight: font.lineHeight * 3
    )
  }

  func testTitleBasedPolicyForMultilinedTitleWithNonNilImage() {
    let font = UIFont.systemFont(ofSize: 50)

    check(
      nativeSizePolicy: .titleLabelBased,
      image: .singleColorImage(.black, size: .square(size: 20)),
      font: font,
      title: """
      x
      y
      z
      """,
      expectedDesiredHeight: font.lineHeight * 3
    )
  }

  func testTitleBasedPolicyForMultilinedTitleWithNonZeroEdgeInsets() {
    let font = UIFont.systemFont(ofSize: 50)

    check(
      nativeSizePolicy: .titleLabelBased,
      contentEdgeInsets: .init(top: 70, bottom: 7),
      image: nil,
      font: font,
      title: """
      x
      y
      z
      """,
      expectedDesiredHeight: font.lineHeight * 3 + 77
    )
  }

  private func check(nativeSizePolicy: DiverseButton.NativeSizePolicy,
                     width: CGFloat = 300,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     image: UIImage?,
                     font: UIFont,
                     title: String?,
                     expectedDesiredWidth: CGFloat? = nil,
                     expectedDesiredHeight: CGFloat? = nil,
                     file: StaticString = #file,
                     line: UInt = #line) {
    let button = DiverseButton()
      .multilined()
      .contentEdgeInsets(contentEdgeInsets)
      .font(font)
      .foreground(.init(title: title, image: image))
      .nativeSizePolicy(nativeSizePolicy)

    let desiredSize = button.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

    if let expectedDesiredWidth {
      if abs(desiredSize.width - expectedDesiredWidth) >= 1 {
        XCTFail(
          """
          Actual desired width \(desiredSize.width) \
          is not equal to expected desired width \(expectedDesiredWidth)
          """,
          file: file,
          line: line
        )
      }
    }


    if let expectedDesiredHeight {
      if abs(desiredSize.height - expectedDesiredHeight) >= 1 {
        XCTFail(
          """
          Actual desired height \(desiredSize.height) \
          is not equal to expected desired height \(expectedDesiredHeight)
          """,
          file: file,
          line: line
        )
      }
    }
  }

  static var allTests = [
    ("Test default policy for large image", testDefaultPolicyForLargeImage),
    ("Test default policy for large font", testDefaultPolicyForLargeFont),
    ("Test title-based policy for singlelined title", testTitleBasedPolicyForSinglelinedTitle),
    ("Test title-based policy for long singlelined title", testTitleBasedPolicyForLongSinglelinedTitle),
    ("Test title-based policy for multilined title", testTitleBasedPolicyForMultilinedTitle),
    (
      "Test title-based policy for multilined title with non-nil image",
      testTitleBasedPolicyForMultilinedTitleWithNonNilImage
    ),
    (
      "Test title-based policy for multilined title with non-zero edge insets",
      testTitleBasedPolicyForMultilinedTitleWithNonZeroEdgeInsets
    ),
  ]
}
