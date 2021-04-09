import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


final class OrderedMultiDictionaryTests: XCTestCase {

  let positivePairs = [("a", 1), ("b", 2), ("c", 3), ("a", 4), ("c", 5)]
  let notPositivePairs = [("a", 1), ("b", 2), ("c", 3), ("a", -4), ("c", 5)]

  func testInitializationFromLiteral() {
    let dictionary: OrderedMultiDictionary = [("a", 1), ("b", 2), ("c", 3), ("a", 4), ("c", 5)]

    XCTAssert(dictionary.keys == ["a", "b", "c", "a", "c"])
    XCTAssert(dictionary.unorderedKeys == ["a", "b", "c"])
    XCTAssert(dictionary.values == [1, 2, 3, 4, 5])
  }

  func testSubscripts() {
    let dictionary = OrderedMultiDictionary(positivePairs)

    XCTAssert(dictionary["a"] == 1)
    XCTAssert(dictionary["b"] == 2)
    XCTAssert(dictionary["c"] == 3)
    XCTAssert(dictionary["d"] == nil)

    XCTAssert(dictionary[all: "a"] == [1, 4])
    XCTAssert(dictionary[all: "b"] == [2])
    XCTAssert(dictionary[all: "c"] == [3, 5])
    XCTAssert(dictionary[all: "d"] == [])

    XCTAssert(dictionary[first: "a"] == 1)
    XCTAssert(dictionary[first: "b"] == 2)
    XCTAssert(dictionary[first: "c"] == 3)
    XCTAssert(dictionary[first: "d"] == nil)

    XCTAssert(dictionary[last: "a"] == 4)
    XCTAssert(dictionary[last: "b"] == 2)
    XCTAssert(dictionary[last: "c"] == 5)
    XCTAssert(dictionary[last: "d"] == nil)
  }

  func testConversionToDictionary() {
    let dictionary = OrderedMultiDictionary(positivePairs)

    XCTAssertEqual(
      dictionary.asDictionary,
      [
        "a": [1, 4],
        "b": [2],
        "c": [3, 5]
      ]
    )
  }

  func testValueReplacing() {
    var dictionary = OrderedMultiDictionary(positivePairs)

    dictionary["d"] = 6
    dictionary["e"] = nil
    dictionary["a"] = nil
    dictionary["c"] = 666

    XCTAssert(dictionary[all: "a"] == [])
    XCTAssert(dictionary[all: "b"] == [2])
    XCTAssert(dictionary[all: "c"] == [666])
    XCTAssert(dictionary[all: "d"] == [6])
    XCTAssert(dictionary[all: "e"] == [])
  }

  func testValueAppending() {
    var dictionary = OrderedMultiDictionary(positivePairs)

    dictionary.append(value: 6, key: "d")
    dictionary.append(value: 666, key: "c")

    XCTAssert(dictionary[all: "a"] == [1, 4])
    XCTAssert(dictionary[all: "b"] == [2])
    XCTAssert(dictionary[all: "c"] == [3, 5, 666])
    XCTAssert(dictionary[all: "d"] == [6])
    XCTAssert(dictionary[all: "e"] == [])
  }

  func testFiltering() {
    let dictionary = OrderedMultiDictionary(notPositivePairs)

    XCTAssert(
      dictionary.filterKeys { $0 == "c" } == [("c", 3), ("c", 5)]
    )

    XCTAssert(
      dictionary.filterValues { $0 > 0 } == [("a", 1), ("b", 2), ("c", 3), ("c", 5)]
    )

    XCTAssert(
      dictionary.filter { $0 == "a" && $1 > 0 } == [("a", 1)]
    )
  }

  func testMapping() {
    let dictionary = OrderedMultiDictionary(notPositivePairs)

    XCTAssertEqual(
      dictionary.mapKeys { Array(repeating: $0, count: 3).joined() },
      [("aaa", 1), ("bbb", 2), ("ccc", 3), ("aaa", -4), ("ccc", 5)]
    )

    XCTAssertEqual(
      dictionary.mapValues { $0 * 7 },
      [("a", 7), ("b", 14), ("c", 21), ("a", -28), ("c", 35)]
    )

    XCTAssertEqual(
      dictionary.map {
        (Array(repeating: $0, count: 3).joined(), $1 * 7)
      },
      [("aaa", 7), ("bbb", 14), ("ccc", 21), ("aaa", -28), ("ccc", 35)]
    )

    XCTAssertEqual(
      dictionary.compactMap {
        if ($0 == "a" || $1 == 3 || $1 == -4) {
          return nil
        } else {
          return (Array(repeating: $0, count: 3).joined(), $1 * 7)
        }
      },
      [("bbb", 14), ("ccc", 35)]
    )
  }

  func testSwapping() {
    let dictionary: OrderedMultiDictionary = [("a", 1), ("b", 2), ("c", 3), ("a", 2), ("c", 2)]
    let swappedDictionary = dictionary.swapped()

    XCTAssert(swappedDictionary == [(1, "a"), (2, "b"), (3, "c"), (2, "a"), (2, "c")])
    XCTAssert(swappedDictionary.keys == [1, 2, 3, 2, 2])
    XCTAssert(swappedDictionary.unorderedKeys == [1, 2, 3])
    XCTAssert(swappedDictionary.values == ["a", "b", "c", "a", "c"])
  }

  func testInitializationFromPairs() {
    10000.times(.orUntilFalse) {
      let pairs = randomPairs()
      let dictionary = OrderedMultiDictionary(pairs)

      let result = dictionary.keysAndValues.isEqualToPairs(pairs)

      if !result {
        XCTFail("\(dictionary).keysAndValues is not equal to \(pairs)")
      }

      return result
    }
  }

  private func randomPairs() -> [(String, Int)] {
    let keys = ["a", "b", "c", "d", "e"]
    let counts = keys.map { ($0, Int.random(in: 0...5)) }

    let multipliedKeys =
      counts.flatMap { Array(repeating: $0, count: $1) }

    let unshuffledPairs = multipliedKeys.map { ($0, Int.random(in: Int.min...Int.max)) }

    return unshuffledPairs.shuffled()
  }

  static var allTests = [
    ("Test initialization from literal", testInitializationFromLiteral),
    ("Test subscripts", testSubscripts),
    ("Test conversion to dictionary", testConversionToDictionary),
    ("Test value replacing", testValueReplacing),
    ("Test value appending", testValueAppending),
    ("Test filtering", testFiltering),
    ("Test mapping", testMapping),
    ("Test swapping", testSwapping),
    ("Test initialization from pairs", testInitializationFromPairs)
  ]
}


private extension Array {

  func isEqualToPairs<A: Equatable, B: Equatable>(_ that: Self) -> Bool where Element == (A, B) {
    zip(self, that).allSatisfy { $0.0 == $1.0 && $0.1 == $1.1 }
  }
}
