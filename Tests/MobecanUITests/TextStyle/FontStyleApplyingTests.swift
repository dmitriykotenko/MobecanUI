import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class FontStyleApplyingTests: XCTestCase {

  let verdanaBold50 = FontStyle(
    familyName: "Verdana",
    size: 50,
    weight: .bold
  )

  let systemFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)

  func testFamilyNameApplying() {
    XCTAssertEqual(
      verdanaBold50.apply(to: systemFont).familyName,
      "Verdana",
      "FontStyle's family name is applied incorrectly"
    )
  }

  func testFamilyNameAndWeightApplying() {
    XCTAssertEqual(
      verdanaBold50.apply(to: systemFont).fontName,
      "Verdana-Bold",
      "FontStyle's family name is applied incorrectly"
    )
  }

  static var allTests = [
    ("Test that family name is applied correctly", testFamilyNameApplying),
    ("Test that family name and weight are applied correctly", testFamilyNameAndWeightApplying),
  ]
}
