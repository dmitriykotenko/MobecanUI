import XCTest

import LayoutKit
import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit
import UIKit

@testable import MobecanUI


class StackViewTextToBulletAlignmentTests: XCTestCase {

  private let texts: [String] = [
    "x",
    "t",
    "g",
    "j",
    "CAPTION",
    "lost",
    "yong",
    "quirell",
    "I think that the loveliest time of the year is Spring. And you? Don't you do? 'Cause you do!"
  ]

  private let fonts: [UIFont] = [
    .systemFont(ofSize: 17),
    .systemFont(ofSize: 24),
    .systemFont(ofSize: 48),
    .systemFont(ofSize: 11),
    .boldSystemFont(ofSize: 19),
    .italicSystemFont(ofSize: 9),
    .monospacedSystemFont(ofSize: 25, weight: .light),
    .monospacedSystemFont(ofSize: 30, weight: .heavy)
  ]

  func testXheightAlignment1() {
    texts.forEach { text in
      fonts.forEach { font in
        check(
          text: text,
          font: font,
          alignment: .xHeight,
          imageViewSize: .init(width: 4, height: 4),
          expectedImageViewY: font.ascender - 0.5 * font.xHeight - 2
        )
      }
    }
  }

  func testXheightAlignment2() {
    texts.forEach { text in
      fonts.forEach { font in
        check(
          text: text,
          font: font,
          alignment: .xHeight,
          imageViewSize: .init(width: 4, height: 400),
          expectedImageViewY: font.ascender - 0.5 * font.xHeight - 200
        )
      }
    }
  }

  func testCapHeightAlignment1() {
    texts.forEach { text in
      fonts.forEach { font in
        check(
          text: text,
          font: font,
          alignment: .capHeight,
          imageViewSize: .init(width: 4, height: 4),
          expectedImageViewY: font.ascender - 0.5 * font.capHeight - 2
        )
      }
    }
  }

  func testCapHeightAlignment2() {
    texts.forEach { text in
      fonts.forEach { font in
        check(
          text: text,
          font: font,
          alignment: .capHeight,
          imageViewSize: .init(width: 4, height: 400),
          expectedImageViewY: font.ascender - 0.5 * font.capHeight - 200
        )
      }
    }
  }

  private func check(text: String,
                     font: UIFont,
                     alignment: TextToBulletAlignment,
                     imageViewSize: CGSize,
                     expectedImageViewY: CGFloat) {
    let imageView = UIImageView.sizable(size: imageViewSize)

    let label = DiverseLabel().multilined()
    label.font = font
    label.text = text

    let stackView = UIView.hstack(
      alignment: alignment,
      spacing: 0,
      bulletView: imageView,
      label: label,
      insets: .zero
    )

    let stackViewContainer = UIView.vstack([stackView])
    stackViewContainer.frame = .init(origin: .zero, size: .init(width: 390, height: 844))

    stackViewContainer.layoutIfNeeded()

    let imageViewFrame = imageView.convert(imageView.bounds, to: stackView)

    XCTAssertEqual(imageViewFrame.origin.y, expectedImageViewY)
  }
}


private extension UIImageView {

  static func sizable(size: CGSize) -> SizableImageView {
    SizableImageView()
      .fixSize(size)
      .contentMode(.scaleAspectFill)
  }
}
