import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class StringIsDoubleSplitTests: XCTestCase {
  
  func testEmptyStringSplit() {
    XCTAssert("".doubleSplit(outerSeparator: "a", innerSeparator: "b") == [])
  }

  func testNonEmptyStringSplit() {
    XCTAssertEqual(
      "Jareth McKenseye".doubleSplit(outerSeparator: " ", innerSeparator: "e"),
      [["Jar", "th"], ["McK", "ns", "y"]]
    )
  }

  static var allTests = [
    ("Test empty string split", testEmptyStringSplit),
    ("Test non-empty string split", testNonEmptyStringSplit)
  ]
}
