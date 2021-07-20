import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class DiverseLabelTests: XCTestCase {

  func testNilTextTransformer() {
    let label = createLabel()
    label.text = "You say"
    XCTAssertEqual(label.text, "You say")
  }

  func testPlainTextTransformer() {
    let label = createLabel()
    label.textTransformer = .plain { $0.map { "[Quiet...] " + $0 } }
    label.text = "You say"
    XCTAssertEqual(label.text, "[Quiet...] You say")
  }

  func testPlainToAttributedTextTransformer() {
    let label = createLabel()

    label.textTransformer = .plainToAttributed {
      $0.map { .colored("Why? ", textColor: .red) + .plain($0) }
    }

    label.text = "You say..."

    let defaultAttributes = label.attributedText?.attributes(at: 0, effectiveRange: nil) ?? [:]

    let expectedText = NSMutableAttributedString(
      attributedString: .colored("Why? ", textColor: .red) + .plain("You say...")
    )

    expectedText.addAttributes(defaultAttributes, range: NSRange(0..<(label.text?.count ?? 0)))

    XCTAssertEqual(
      label.attributedText,
      expectedText
    )
  }

  func testAttributedTextTransformer() {
    let label = createLabel()

    label.textTransformer = .attributed {
      $0.map {
        .plain($0.string) + .colored("Why? ", textColor: .red)
      }
    }

    label.text = "You say..."
    let ddd = label.attributedText
    label.attributedText = ddd

    XCTAssertEqual(
      label.attributedText,
      .plain("You say...") + .colored("Why? ", textColor: .red)
    )
  }

  private func createLabel() -> DiverseLabel {
    let label = DiverseLabel()

    label.font = .boldSystemFont(ofSize: 25)
    label.textColor = .systemYellow

    return label
  }

  static var allTests = [
    ("Test nil text transformer", testNilTextTransformer),
    ("Test plain text transformer", testPlainTextTransformer),
    ("Test plain-to-attributed text transformer", testPlainToAttributedTextTransformer),
    ("Test attributed text transformer", testAttributedTextTransformer)
  ]
}
