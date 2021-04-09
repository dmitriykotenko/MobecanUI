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

  func testNotBlankOrNil() {
    XCTAssert("   ".notBlankOrNil == nil)
    XCTAssert(("   " as String?).notBlankOrNil == nil)
    XCTAssert((nil as String?).notBlankOrNil == nil)

    XCTAssert(" You cry,..  ".notBlankOrNil == " You cry,..  ")
    XCTAssert((" You cry,..  " as String?).notBlankOrNil == " You cry,..  ")
  }

  func testNotBlankOrDefaultValue() {
    XCTAssert("   ".notBlank(or: "!") == "!")
    XCTAssert(("   " as String?).notBlank(or: "!") == "!")
    XCTAssert((nil as String?).notBlank(or: "!") == "!")

    XCTAssert(" You cry,..  ".notBlank(or: "!") == " You cry,..  ")
    XCTAssert((" You cry,..  " as String?).notBlank(or: "!") == " You cry,..  ")
  }

  func testFilteringOfNotBlanks() {
    let strings = ["  \t \n", "...say me 'Good-bye!'", ""]
    let optionalStrings: [String?] = ["  \t \n", "...say me 'Good-bye!'", nil, "", nil, nil]

    XCTAssert(strings.filterNotBlank() == ["...say me 'Good-bye!'"])
    XCTAssert(optionalStrings.filterNotBlank() == ["...say me 'Good-bye!'"])
  }

  static var allTests = [
    ("Test that empty string is blank", testThatEmptyStringIsBlank),
    ("Test that sequence of spaces and tabs is blank", testThatSequenceOfSpacesAndTabsIsBlank),
    ("Test that single dot is not blank", testThatSingleDotIsNotBlank),
    ("Test long phrase is not blank", testThatLongPhraseIsNotBlank),
    ("Test .notBlankOrNil", testNotBlankOrNil),
    ("Test .notBlank(or:)", testNotBlankOrDefaultValue),
    ("Test filtering of not-blanks", testFilteringOfNotBlanks)
  ]
}
