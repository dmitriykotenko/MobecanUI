// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


final class BoolDeserializationTests: DeserializationTester {

  func testValidBool1() {
    check(
      deserializedType: Bool.self,
      jsonString: "false",
      expectedResult: .success(false)
    )
  }

  func testValidBool2() {
    check(
      deserializedType: Bool.self,
      jsonString: "true",
      expectedResult: .success(true)
    )
  }

  func testInvalidBool1() {
    check(
      deserializedType: Bool.self, 
      jsonString: "0",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidBool2() {
    check(
      deserializedType: Bool.self,
      jsonString: "0.7",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found number instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidBool3() {
    check(
      deserializedType: Bool.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidBool4() {
    check(
      deserializedType: Bool.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testInvalidBool5() {
    check(
      deserializedType: Bool.self,
      jsonString: "{}",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found a dictionary instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNullBool1() {
    check(
      deserializedType: Bool?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testNullBool2() {
    check(
      deserializedType: Bool.self,
      jsonString: "null",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: Bool.self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Bool but found null instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: Bool.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: Bool.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
