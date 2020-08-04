import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class ArrayPairingTests: XCTestCase {
  
  func testPairingOfEmptyArray() {
    checkArrays(
      actual: [].paired(with: [1, 2, 3]) { $0 == $1 },
      expected: []
    )
  }

  func testPairingWithEmptyArray() {
    checkArrays(
      actual: [1, 2, 3].paired(with: []) { $0 == $1 },
      expected: []
    )
  }

  func testPairingWithSelf() {
    checkArrays(
      actual: [1, 2, 3, 4, 5].paired(with: [5, 3, 2, 4, 1]) { $0 == $1 },
      expected: [(1, 1), (2, 2), (3, 3), (4, 4), (5, 5)]
    )
  }

  func testPairingWithCompletelyDifferentArray() {
    checkArrays(
      actual: [1, 2, 3].paired(with: [4, 5, 6, 7]) { $0 == $1 },
      expected: []
    )
  }
  
  func testPairingOfArrayWithDuplicates() {
    checkArrays(
      actual: [4, 1, 2, 3, 4, 1, 1, 5].paired(with: [1, 2, 3]) { $0 == $1 },
      expected: [(1, 1), (2, 2), (3, 3), (1, 1), (1, 1)]
    )
  }

  @discardableResult
  private func checkArrays(actual: [(Int, Int)],
                           expected: [(Int, Int)]) -> Bool {
    if actual.count != expected.count {
      XCTFail("Actual array is \(actual), but expected array is \(expected).")
    }
    
    let differences = zip(actual, expected).filter { $0.0 != $1.0 || $0.1 != $1.1 }
    
    if !differences.isEmpty {
      XCTFail("Actual array is \(actual), but expected array is \(expected).")
    }
    
    return differences.isEmpty
  }

  static var allTests = [
    ("Test pairing of empty array", testPairingOfEmptyArray),
    ("Test pairing with empty array", testPairingWithEmptyArray),
    ("Test pairing with self", testPairingWithSelf),
    ("Test pairing with completely different array", testPairingWithCompletelyDifferentArray),
    ("Test pairing of array with duplicates", testPairingOfArrayWithDuplicates),
  ]
}
