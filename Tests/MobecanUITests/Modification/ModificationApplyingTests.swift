import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class ModificationApplyingTests: XCTestCase {

  func testCreationInArray() {
    check(
      oldArray: ["Rick", "Beth"],
      modification: .create("Morty"),
      expectedNewArray: ["Rick", "Beth", "Morty"]
    )
  }

  func testUpdateInArray() {
    check(
      oldArray: ["Rick", "Beth", "Rick"],
      modification: .update(old: "Rick", new: "Morty"),
      expectedNewArray: ["Morty", "Beth", "Morty"]
    )
  }

  func testUpdateOfNonExistentElementInArray() {
    check(
      oldArray: ["Rick", "Beth", "Rick"],
      modification: .update(old: "Jerry", new: "Morty"),
      expectedNewArray: ["Rick", "Beth", "Rick"]
    )
  }

  func testDeletionFromArray() {
    check(
      oldArray: ["Rick", "Beth"],
      modification: .delete("Rick"),
      expectedNewArray: ["Beth"]
    )
  }

  func testDeletionOfNonExistentElementFromArray() {
    check(
      oldArray: ["Rick", "Beth"],
      modification: .delete("Morty"),
      expectedNewArray: ["Rick", "Beth"]
    )
  }

  func testCreationInSet() {
    check(
      oldSet: ["Rick", "Beth"],
      modification: .create("Morty"),
      expectedNewSet: ["Rick", "Beth", "Morty"]
    )
  }

  func testUpdateInSet() {
    check(
      oldSet: ["Beth", "Rick"],
      modification: .update(old: "Rick", new: "Morty"),
      expectedNewSet: ["Morty", "Beth"]
    )
  }

  func testUpdateOfNonExistentElementInSet() {
    check(
      oldSet: ["Beth", "Rick"],
      modification: .update(old: "Jerry", new: "Morty"),
      expectedNewSet: ["Beth", "Rick"]
    )
  }

  func testDeletionFromSet() {
    check(
      oldSet: ["Rick", "Beth"],
      modification: .delete("Rick"),
      expectedNewSet: ["Beth"]
    )
  }

  func testDeletionOfNonExistentElementFromSet() {
    check(
      oldSet: ["Rick", "Beth"],
      modification: .delete("Morty"),
      expectedNewSet: ["Rick", "Beth"]
    )
  }

  private func check(oldArray: [String],
                     modification: Modification<String>,
                     expectedNewArray: [String]) {
    XCTAssertEqual(
      modification.apply(to: oldArray),
      expectedNewArray
    )
  }

  private func check(oldSet: Set<String>,
                     modification: Modification<String>,
                     expectedNewSet: Set<String>) {
    XCTAssertEqual(
      modification.apply(to: oldSet),
      expectedNewSet
    )
  }

  static var allTests = [
    ("Test creation in array", testCreationInArray),
    ("Test update in array", testUpdateInArray),
    ("Test update of non-existent element in array", testUpdateOfNonExistentElementInArray),
    ("Test deletion from array", testDeletionFromArray),
    ("Test deletion of non-existent element from array", testDeletionOfNonExistentElementFromArray),

    ("Test creation in set", testCreationInSet),
    ("Test update in set", testUpdateInSet),
    ("Test update of non-existent element in set", testUpdateOfNonExistentElementInSet),
    ("Test deletion from set", testDeletionFromSet),
    ("Test deletion of non-existent element from set", testDeletionOfNonExistentElementFromSet),
  ]
}
