import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class StringIsBlankTests: XCTestCase {
  
  func testThatEmptyStringIsBlank() {
    XCTAssert("".isBlank)
  }

  func testThatSequenceOfSpacesAndTabsIsBlank() {
    XCTAssert("\t  \n \r  \t\t   ".isBlank)
  }

  func testThatSingleDotIsNotBlank() {
    XCTAssert("·".isNotBlank)
  }

  func testThatLongPhraseIsNotBlank() {
    XCTAssert(
      "   You say: the price of my love's not a price that you're willing to pay... ".isNotBlank
    )
  }

  static var allTests = [
    ("Test that empty string is blank", testThatEmptyStringIsBlank),
    ("Test that sequence of spaces and tabs is blank", testThatSequenceOfSpacesAndTabsIsBlank),
    ("Test that single dot is not blank", testThatSingleDotIsNotBlank),
    ("Test long phrase is not blank", testThatLongPhraseIsNotBlank)
  ]
}
