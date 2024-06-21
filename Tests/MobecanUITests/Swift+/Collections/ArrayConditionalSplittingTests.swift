import XCTest

@testable import MobecanUI


final class ArrayConditionalSplittingTests: XCTestCase {

  func testEmptyArray() {
    check(
      array: [],
      splitWhile: { _, _ in true },
      expectedPair: ([], [])
    )

    check(
      array: [],
      splitWhile: { _, _ in false },
      expectedPair: ([], [])
    )

    check(
      array: [],
      splitWhileFromRight: { _, _ in true },
      expectedPair: ([], [])
    )

    check(
      array: [],
      splitWhileFromRight: { _, _ in false },
      expectedPair: ([], [])
    )
  }

  func testNeverEndingSplitting() {
    check(
      array: [1, 2, 3, 4, 5],
      splitWhile: { _, _ in true },
      expectedPair: ([1, 2, 3, 4, 5], [])
    )

    check(
      array: [1, 2, 3, 4, 5],
      splitWhileFromRight: { _, _ in true },
      expectedPair: ([], [1, 2, 3, 4, 5])
    )
  }

  func testSplittingAtEvenNumber() {
    check(
      array: [1, 2, 3, 4, 5],
      splitWhile: { $1 % 2 != 0 },
      expectedPair: ([1], [2, 3, 4, 5])
    )

    check(
      array: [1, 2, 3, 4, 5],
      splitWhileFromRight: { element, _ in element % 2 != 0 },
      expectedPair: ([1, 2, 3, 4], [5])
    )
  }

  func testComplexSplitting() {
    check(
      array: [3, 5, 10, 15, 20],
      splitWhile: { $0.count < 2 || $1 % 3 != 0 },
      expectedPair: ([3, 5, 10], [15, 20])
    )

    check(
      array: [3, 5, 10, 15, 20],
      splitWhileFromRight: { $0 % 3 != 0 || $1.count < 2 },
      expectedPair: ([3], [5, 10, 15, 20])
    )
  }

  private func check(array: [Int],
                     splitWhile: ([Int], Int) -> Bool,
                     expectedPair: ([Int], [Int]),
                     file: StaticString = #file,
                     line: UInt = #line) {
    let actualPair = array.splitWhile(splitWhile)

    XCTAssertEqual(
      actualPair.0,
      expectedPair.0,
      file: file,
      line: line
    )

    XCTAssertEqual(
      actualPair.1,
      expectedPair.1,
      file: file,
      line: line
    )
  }

  private func check(array: [Int],
                     splitWhileFromRight: (Int, [Int]) -> Bool,
                     expectedPair: ([Int], [Int]),
                     file: StaticString = #file,
                     line: UInt = #line) {
    let actualPair = array.splitWhileFromRight(splitWhileFromRight)

    XCTAssertEqual(
      actualPair.0,
      expectedPair.0,
      file: file,
      line: line
    )

    XCTAssertEqual(
      actualPair.1,
      expectedPair.1,
      file: file,
      line: line
    )
  }
}
