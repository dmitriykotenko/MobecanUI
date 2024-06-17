// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift
import SwiftDateTime

@testable import MobecanUI


final class JsonValueDeserializationTests: DeserializationTester {

  func testSimpleJson1() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "null",
      expectedResult: .success(.null)
    )
  }

  func testSimpleJson2() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "false",
      expectedResult: .success(.bool(false))
    )
  }

  func testSimpleJson3() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "0",
      expectedResult: .success(.int(0))
    )
  }

  func testSimpleJson4() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "0.0",
      expectedResult: .success(.int(0))
    )
  }

  func testSimpleJson5() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "0.5",
      expectedResult: .success(.double(0.5))
    )
  }

  func testSimpleJson6() {
    check(
      deserializedType: JsonValue.self,
      jsonString: """
      "Run, Forest!"
      """,
      expectedResult: .success(.string("Run, Forest!"))
    )
  }

  func testSimpleJson7() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "[]",
      expectedResult: .success(.array([]))
    )
  }

  func testSimpleJson9() {
    check(
      deserializedType: JsonValue.self,
      jsonString: "{}",
      expectedResult: .success(.object([:]))
    )
  }

  func testComplexJson1() {
    check(
      deserializedType: JsonValue.self,
      jsonString: """
      [
        "Run, Forest!",
        {},
        null,
        7,
        8.8,
        true,
        [false]
      ]
      """,
      expectedResult: .success(.array([
        .string("Run, Forest!"),
        .object([:]),
        .null,
        .int(7),
        .double(8.8),
        .bool(true),
        .array([.bool(false)])
      ]))
    )
  }

  func testComplexJson2() {
    check(
      deserializedType: JsonValue.self,
      jsonString: """
      {
        "a": 1,
        "b": "2",
        "c": 3.3,
        "d": true,
        "e": null,
        "f": [null, 9, {"x": "999"}],
        "g": {
          "h": [],
          "i": 500.1,
          "j": {"k": "11th letter of alphabet"}
        }
      }
      """,
      expectedResult: .success(.object([
        "a": .int(1),
        "b": .string("2"),
        "c": .double(3.3),
        "d": .bool(true),
        "e": .null,
        "f": .array([
          .null, 
          .int(9),
          .object(["x": .string("999")])
        ]),
        "g": .object([
          "h": .array([]),
          "i": .double(500.1),
          "j": .object(["k": .string("11th letter of alphabet")])
        ])
      ]))
    )
  }

  func testDeserializationOfOptionalJsonValue() {
    check(
      deserializedType: JsonValue?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }

  func testCorruptedJson1() {
    check(
      deserializedType: JsonValue.self,
      jsonString: corruptedJson1,
      expectedDecodingError: errorWhenDecodingCorruptedJson1
    )
  }

  func testCorruptedJson2() {
    check(
      deserializedType: JsonValue.self,
      jsonString: corruptedJson2,
      expectedDecodingError: errorWhenDecodingCorruptedJson2
    )
  }
}
