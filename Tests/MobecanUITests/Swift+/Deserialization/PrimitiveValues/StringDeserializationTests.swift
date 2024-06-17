// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class StringDeserializationTests: DeserializationTester {

  func testValidString1() {
    check(
      deserializedType: String.self,
      jsonString: """
      ""
      """,
      expectedResult: .success("")
    )
  }

  func testValidString2() {
    check(
      deserializedType: String.self,
      jsonString: """
      "I'm a «🕵🏻‍♂️» and a „🦄“ из 🇪🇨"
      """,
      expectedResult: .success(
        "I'm a «🕵🏻‍♂️» and a „🦄“ из 🇪🇨"
      )
    )
  }

  func testInvalidString1() {
    check(
      deserializedType: String.self,
      jsonString: "false",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidString2() {
    check(
      deserializedType: String.self,
      jsonString: "0",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidString3() {
    check(
      deserializedType: String.self,
      jsonString: "1.2345",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidString4() {
    check(
      deserializedType: String.self,
      jsonString: "88888888888888888888888888888888888888888888888888888888888888888888",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidString5() {
    check(
      deserializedType: String.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidString6() {
    check(
      deserializedType: String.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode String but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNullString1() {
    check(
      deserializedType: String?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullString2() {
    check(
      deserializedType: String.self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: String.self),
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
      deserializedType: String.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: String.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
