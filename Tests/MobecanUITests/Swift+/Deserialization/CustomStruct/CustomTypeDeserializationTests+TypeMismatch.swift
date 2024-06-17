// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension CustomTypeDeserializationTests {

  func testTopLevelTypeMismatch1() {
    check(
      deserializedType: Match.self,
      jsonString: """
      ""
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Dictionary<String, Any> but found a string instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testTopLevelTypeMismatch2() {
    check(
      deserializedType: Match.self,
      jsonString: "[]",
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [],
          debugDescription: "Expected to decode Dictionary<String, Any> but found an array instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch1() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
          {
            "name" : {
              "firstName" : "Чачечич",
              "lastName" : "Чичуев"
            },
            "height" : 1.99,
            "mainHand" : "left",
            "id" : 1
          },
          {
            "name" : {
              "firstName" : "Дурр",
              "lastName" : "Швамм"
            },
            "height" : null,
            "id" : 2,
            "mainHand" : "right"
          }
        ],
        "score" : {
          "sets" : false
        }
      }
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [Any].self),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets")
          ],
          debugDescription: "Expected to decode Array<Any> but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch2() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
          {
            "name" : {
              "firstName" : "Чачечич",
              "lastName" : "Чичуев"
            },
            "height" : 1.99,
            "mainHand" : "left",
            "id" : 1
          },
          {
            "name" : {
              "firstName" : "Дурр",
              "lastName" : "Швамм"
            },
            "height" : null,
            "id" : 2,
            "mainHand" : "right"
          }
        ],
        "score" : {
          "sets" : [false]
        }
      }
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: [String: Any].self),
        context: .init(
          codingPath: [
            codingKey("score"),
            codingKey("sets"),
            codingKey(0)
          ],
          debugDescription: "Expected to decode Dictionary<String, Any> but found bool instead.",
          underlyingError: nil
        )
      )
    )
  }

  func testNestedTypeMismatch3() {
    check(
      deserializedType: Match.self,
      jsonString: """
      {
        "players" : [
          {
            "name" : {
              "firstName" : "Чачечич",
              "lastName" : "Чичуев"
            },
            "height" : 1.99,
            "mainHand" : "left",
            "id" : 1
          },
          {
            "name" : {
              "firstName" : "Дурр",
              "lastName" : 800
            },
            "height" : null,
            "id" : 2,
            "mainHand" : "right"
          }
        ],
        "score" : {
          "sets" : []
        }
      }
      """,
      expectedDecodingError: .typeMismatch(
        expectedType: .init(type: String.self),
        context: .init(
          codingPath: [
            codingKey("players"),
            codingKey(1),
            codingKey("name"),
            codingKey("lastName")
          ],
          debugDescription: "Expected to decode String but found number instead.",
          underlyingError: nil
        )
      )
    )
  }
}
