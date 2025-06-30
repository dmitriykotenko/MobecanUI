// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class IntBasedEnumDeserializationTests: DeserializationTester {

  func testValidEnum1() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "0",
      expectedResult: .success(.zero)
    )
  }

  func testValidEnum2() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "-2",
      expectedResult: .success(.minusTwo)
    )
  }

  func testValidEnum3() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "666",
      expectedResult: .success(.sixHundredsSixtySix)
    )
  }

  func testEmptyString() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Int but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testUnknownEnumCase1() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "1",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Cannot initialize GoodNumbersEnum from invalid Int value 1",
          underlyingError: nil
        )
      )
    )
  }

  func testUnknownEnumCase2() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "2",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "Cannot initialize GoodNumbersEnum from invalid Int value 2",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch1() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "false",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Int but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch2() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: """
      "0"
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Int but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch3() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Int but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch4() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Int but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTypeMismatch5() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "3.5",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError:
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: ["NSDebugDescription": "Number 3.5 is not representable in Swift."]
            )
            .stableDescription
        )
      )
    )
  }

  func testNullEnum1() {
    check(
      deserializedType: GoodNumbersEnum?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullEnum2() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: unexpectedNullErrorMessage(exectedType: Int.self),
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: GoodNumbersEnum.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
