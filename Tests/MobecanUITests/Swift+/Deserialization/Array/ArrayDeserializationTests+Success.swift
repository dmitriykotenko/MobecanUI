// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension ArrayDeserializationTests {

  func testEmptyArray() {
    check(
      deserializedType: [Match].self,
      jsonString: "[]",
      expectedResult: .success([])
    )
  }

  func testValidArray1() {
    check(
      deserializedType: [String].self,
      jsonString: """
      ["a", "b", "c"]
      """,
      expectedResult: .success(["a", "b", "c"])
    )
  }

  func testValidArray2() {
    check(
      deserializedType: [Player.Name].self,
      jsonString: """
      [
        {
          "firstName" : "Чачечич",
          "lastName" : "Чичуев"
        },
        {
          "firstName" : "Дурр",
          "lastName" : "Швамм"
        },
      ]
      """,
      expectedResult: .success([
        .init(
          firstName: "Чачечич",
          lastName: "Чичуев"
        ),
        .init(
          firstName: "Дурр",
          lastName: "Швамм"
        )
      ])
    )
  }

  func testValidArray3() {
    check(
      deserializedType: [JsonValue].self,
      jsonString: """
      [
        {
          "firstName" : "Чачечич",
          "lastName" : "Чичуев"
        },
        null,
        [
          {
            "firstName" : "Дурр",
            "lastName" : "Швамм"
          }
        ],
        999
      ]
      """,
      expectedResult: .success([
        .object([
          "firstName": .string("Чачечич"),
          "lastName": .string("Чичуев")
        ]),
        .null,
        .array([
          .object([
            "firstName": .string("Дурр"),
            "lastName": .string("Швамм")
          ])
        ]),
        .int(999)
      ])
    )
  }

  func testDeserializationOfOptionalArray() {
    check(
      deserializedType: [Match]?.self,
      jsonString: "null",
      expectedResult: .success(nil)
    )
  }
}
