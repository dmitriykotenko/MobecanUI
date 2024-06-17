// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class IntDeserializationTests: DeserializationTester {

  func testValidInt1() {
    check(
      deserializedType: Int.self,
      jsonString: "0",
      expectedResult: .success(0)
    )
  }

  func testValidInt2() {
    check(
      deserializedType: Int.self,
      jsonString: "5.0",
      expectedResult: .success(5)
    )
  }

  func testValidInt3() {
    check(
      deserializedType: Int.self,
      jsonString: "-4444",
      expectedResult: .success(-4444)
    )
  }

  func testInvalidInt1() {
    check(
      deserializedType: Int.self, 
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

  func testInvalidInt2() {
    check(
      deserializedType: Int.self,
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

  func testInvalidInt3() {
    check(
      deserializedType: Int.self,
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

  func testInvalidInt4() {
    check(
      deserializedType: Int.self,
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

  func testInvalidInt5() {
    check(
      deserializedType: Int.self,
      jsonString: "-1.1",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError: 
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: ["NSDebugDescription": "Number -1.1 is not representable in Swift."]
            )
            .stableDescription
        )
      )
    )
  }

  func testInvalidInt6() {
    check(
      deserializedType: Int.self,
      jsonString: "666666666666666666666666666666666666",
      expectedDecodingError: .dataCorrupted(
        context: .init(
          codingPath: [],
          debugDescription: "The given data was not valid JSON.",
          underlyingError:
            NSError(
              domain: "NSCocoaErrorDomain",
              code: 3840,
              userInfo: [
                "NSDebugDescription": "Number 666666666666666666666666666666666666 is not representable in Swift."
              ]
            )
            .stableDescription
        )
      )
    )
  }

  func testNullInt1() {
    check(
      deserializedType: Int?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullInt2() {
    check(
      deserializedType: Int.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: Int.self),
        context: .init(
          codingPath: [],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: Int.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: Int.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
